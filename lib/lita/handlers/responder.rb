module Lita
  module Handlers
    class Responder < Handler
      def self.default_config(config)
        config.cleverbot = false
      end

      route %r{^responder add\s+(.+)\s+->\s+(.+)\s*$}i,
        :add_responder, command: true, restrict_to: [:admins, :responder_admins],
        help: {'lita-responder' => 'see https://github.com/Maysora/lita-responder'}

      route %r{^responder (destroy|delete|remove)\s+(.+)\s*$}i,
        :remove_responder, command: true, restrict_to: [:admins, :responder_admins]

      route %r{^responder list$}i,
        :list_responder, command: true, restrict_to: [:admins, :responder_admins]

      route %r{^responder reset$}i,
        :reset_responder, command: true, restrict_to: [:admins]

      route %r{^(.+)$}, :ask_responder, command: true, exclusive: true

      def add_responder(response)
        question = response.matches[0][0]
        answer = response.matches[0][1]

        update_answer question, answer

        response.reply_with_mention "I have added '#{answer}' to '#{question}' question"
      end

      def remove_responder(response)
        question = response.matches[0][1]

        if redis.exists("lita-responder:#{question.downcase}")
          redis.del("lita-responder:#{question.downcase}")
        end
        response.reply_with_mention "I have removed '#{question}' question"
      end

      def list_responder(response)
        if !questions.empty?
          response.reply_with_mention '- ' + questions.map{|q| q.sub('lita-responder:', '') }.join("\n- ")
        else
          response.reply_with_mention 'I don\'t have any question-answers stored'
        end
      end

      def reset_responder(response)
        count = questions.empty? ? 0 : redis.del(questions)
        response.reply_with_mention "#{count} question(s) removed"
      end

      def ask_responder(response)
        question = response.matches[0][0]
        answer = get_answer(question)
        if !answer && config.cleverbot
          bots = robot.instance_variable_get('@cleverbots') || {}
          bot = bots[response.user.mention_name] ||= Cleverbot::Client.new
          answer = bot.write question
          robot.instance_variable_set('@cleverbots', bots)
        end
        response.reply_with_mention answer if answer
      end

      private

      def questions
        @questions ||= redis.keys('lita-responder:*')
      end

      def get_answer(question)
        question = questions.detect { |q| Regexp.new(q.sub('lita-responder:', ''), 'i') =~ question }
        return nil unless question
        redis.get(question)
      end

      def update_answer(question, answer)
        redis.set "lita-responder:#{question.downcase}", answer
      end
    end

    Lita.register_handler(Responder)
  end
end
