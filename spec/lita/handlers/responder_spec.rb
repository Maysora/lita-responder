require "spec_helper"

describe Lita::Handlers::Responder, lita_handler: true do
  it { routes_command('responder add aya hirano -> cute').to(:add_responder) }
  it { routes_command('responder destroy aya hirano').to(:remove_responder) }
  it { routes_command('responder delete aya hirano').to(:remove_responder) }
  it { routes_command('responder remove aya hirano').to(:remove_responder) }
  it { routes_command('responder list').to(:list_responder) }
  it { routes_command('responder reset').to(:reset_responder) }
  it { routes_command('aya hirano for life!').to(:ask_responder) }
  it { doesnt_route('responder list').to(:ask_responder) }

  before do
    allow(Lita::Authorization).to receive(:user_in_group?).with(user, :responder_admins).and_return(false)
    allow(Lita::Authorization).to receive(:user_in_group?).with(user, :admins).and_return(false)
  end

  it 'config.cleverbot default to false' do
    expect(Lita.config.handlers.responder.cleverbot).to be false
  end

  it 'disallow responder add' do
    send_command('responder add aya hirano -> cute')
    expect(replies.last).to be_nil
  end

  it 'disallow responder reset' do
    send_command('responder reset')
    expect(replies.last).to be_nil
  end

  context 'responder_admins user' do
    before do
      allow(Lita::Authorization).to receive(:user_in_group?).with(user, :responder_admins).and_return(true)
    end

    it 'allow responder add' do
      send_command('responder add aya hirano -> cute')
      expect(replies.first).to match(/^I have added/) # use first because exclusive extension not applied here
      send_command('responder delete aya hirano')
      expect(replies.last).to match(/^I have removed/)
    end

    it 'disallow responder reset' do
      send_command('responder reset')
      expect(replies.last).to be_nil
    end
  end

  context 'admins user' do
    before do
      allow(Lita::Authorization).to receive(:user_in_group?).with(user, :admins).and_return(true)
    end

    it 'allow responder add' do
      send_command('responder add aya hirano -> cute')
      expect(replies.first).to match(/^I have added/)
      send_command('responder remove aya hirano')
      expect(replies.last).to match(/^I have removed/)
    end

    it 'allow responder reset' do
      send_command('responder reset')
      expect(replies.last).to match(/removed$/)
    end
  end
end
