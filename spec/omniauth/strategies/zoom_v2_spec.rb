# frozen_string_literal: true

RSpec.describe OmniAuth::Strategies::ZoomV2 do # rubocop:disable RSpec/SpecFilePathFormat
  let(:options) { {} }
  let(:strategy) { described_class.new('app', 'client_id', 'client_secret', options) }

  describe 'default options' do
    it 'has correct default values' do
      expect(strategy.options.name).to eq('zoom_v2')
      expect(strategy.options.client_options.site).to eq('https://zoom.us')
      expect(strategy.options.client_options.authorize_url).to eq('/oauth/authorize')
      expect(strategy.options.client_options.token_url).to eq('/oauth/token')
    end
  end

  describe 'custom options' do
    context 'with custom scope' do
      let(:options) { { scope: 'user:read:user' } }

      it 'uses custom scope' do
        expect(strategy.options.scope).to eq('user:read:user')
      end
    end
  end

  describe '#uid' do
    let(:raw_info) { { 'id' => 'Wk9PTV9VU0VSX0lE' } }

    before { allow(strategy).to receive(:raw_info).and_return(raw_info) }

    it 'returns the id from raw_info' do
      expect(strategy.uid).to eq('Wk9PTV9VU0VSX0lE')
    end
  end

  describe '#info' do
    let(:raw_info) do
      {
        'id' => 'Wk9PTV9VU0VSX0lE',
        'first_name' => 'Jane',
        'last_name' => 'Dev',
        'display_name' => 'Jane Dev',
        'email' => 'jane.dev@example.com',
        'type' => 2,
        'role_name' => 'Owner',
        'pmi' => 1234567890,
        'use_pmi' => false,
        'personal_meeting_url' => 'https://janedev.zoom.us/j/1234567890?pwd=Wk9PTV9QTUlfUEFTU0NPREU',
        'timezone' => 'America/Denver',
        'verified' => 1,
        'dept' => '',
        'created_at' => '2019-04-05T15:24:32Z',
        'last_login_time' => '2025-03-19T22:42:47Z',
        'last_client_version' => '6.4.0.51205(mac)',
        'pic_url' => 'https://janedev.zoom.us/p/v2/Wk9PTV9QSUNfVVJM/Wk9PTV9QSUNfVVJM',
        'cms_user_id' => '',
        'jid' => 'Wk9PTV9VU0VSX0lE@xmpp.zoom.us',
        'group_ids' => [
          'Wk9PTV9HUk9VUF9JRA'
        ],
        'im_group_ids' => [
          'Wk9PTV9HUk9VUF9JRA'
        ],
        'account_id' => 'Wk9PTV9BQ0NPVU5UX0lE',
        'language' => 'en-US',
        'phone_country' => 'US',
        'phone_number' => '+1 1234567890',
        'status' => 'active',
        'job_title' => '',
        'cost_center' => '',
        'company' => 'Zoom',
        'location' => 'Denver, CO, USA',
        'custom_attributes' => [
          {
            'key' => 'Wk9PTV9DVVNUT01fQVRUUklCVVRFX0tFWQ',
            'name' => 'Test',
            'value' => 'set from API'
          }
        ],
        'login_types' => [
          1,
          100
        ],
        'role_id' => '0',
        'account_number' => 12345678,
        'cluster' => 'aw1',
        'phone_numbers' => [
          {
            'country' => 'US',
            'code' => '+1',
            'number' => '1234567890',
            'verified' => false,
            'label' => ''
          }
        ],
        'user_created_at' => '2019-04-05T15:23:55Z'
      }
    end

    before { allow(strategy).to receive(:raw_info).and_return(raw_info) }

    it 'returns correct info hash' do
      info = strategy.info
      expect(info).to eq(
        name: 'Jane Dev',
        first_name: 'Jane',
        last_name: 'Dev',
        nickname: 'Jane Dev',
        email: 'jane.dev@example.com',
        image: 'https://janedev.zoom.us/p/v2/Wk9PTV9QSUNfVVJM/Wk9PTV9QSUNfVVJM',
        location: 'Denver, CO, USA',
        verified: 1,
        urls: {
          zoom: 'https://janedev.zoom.us/j/1234567890?pwd=Wk9PTV9QTUlfUEFTU0NPREU'
        }
      )
    end

    it 'prunes empty values' do
      allow(strategy).to receive(:raw_info).and_return({
        'id' => 'Wk9PTV9VU0VSX0lE',
        'first_name' => '',
        'last_name' => '',
        'display_name' => '',
        'email' => '',
        'pic_url' => '',
        'location' => '',
        'verified' => nil,
        'personal_meeting_url' => ''
      })
      info = strategy.info
      expect(info).to eq({})
    end

    it 'handles names correctly' do
      allow(strategy).to receive(:raw_info).and_return({
        'id' => 'Wk9PTV9VU0VSX0lE',
        'first_name' => 'John',
        'last_name' => 'Doe'
      })
      info = strategy.info
      expect(info[:name]).to eq('John Doe')
      expect(info[:first_name]).to eq('John')
      expect(info[:last_name]).to eq('Doe')
    end

    it 'handles single name correctly' do
      allow(strategy).to receive(:raw_info).and_return({
        'id' => 'test',
        'first_name' => 'John',
        'last_name' => ''
      })
      info = strategy.info
      expect(info[:name]).to eq('John')
      expect(info[:first_name]).to eq('John')
      expect(info).not_to have_key(:last_name)
    end
  end

  describe '#extra' do
    let(:raw_info) do
      {
        'id' => 'Wk9PTV9VU0VSX0lE',
        'first_name' => 'Jane',
        'last_name' => 'Dev',
        'display_name' => 'Jane Dev',
        'email' => 'jane.dev@example.com',
        'type' => 2,
        'role_name' => 'Owner',
        'pmi' => 1234567890,
        'use_pmi' => false,
        'personal_meeting_url' => 'https://janedev.zoom.us/j/1234567890?pwd=Wk9PTV9QTUlfUEFTU0NPREU',
        'timezone' => 'America/Denver',
        'verified' => 1,
        'dept' => '',
        'created_at' => '2019-04-05T15:24:32Z',
        'last_login_time' => '2025-03-19T22:42:47Z',
        'last_client_version' => '6.4.0.51205(mac)',
        'pic_url' => 'https://janedev.zoom.us/p/v2/Wk9PTV9QSUNfVVJM/Wk9PTV9QSUNfVVJM',
        'cms_user_id' => '',
        'jid' => 'Wk9PTV9VU0VSX0lE@xmpp.zoom.us',
        'group_ids' => [
          'Wk9PTV9HUk9VUF9JRA'
        ],
        'im_group_ids' => [
          'Wk9PTV9HUk9VUF9JRA'
        ],
        'account_id' => 'Wk9PTV9BQ0NPVU5UX0lE',
        'language' => 'en-US',
        'phone_country' => 'US',
        'phone_number' => '+1 1234567890',
        'status' => 'active',
        'job_title' => '',
        'cost_center' => '',
        'company' => 'Zoom',
        'location' => 'Denver, CO, USA',
        'custom_attributes' => [
          {
            'key' => 'Wk9PTV9DVVNUT01fQVRUUklCVVRFX0tFWQ',
            'name' => 'Test',
            'value' => 'set from API'
          }
        ],
        'login_types' => [
          1,
          100
        ],
        'role_id' => '0',
        'account_number' => 12345678,
        'cluster' => 'aw1',
        'phone_numbers' => [
          {
            'country' => 'US',
            'code' => '+1',
            'number' => '1234567890',
            'verified' => false,
            'label' => ''
          }
        ],
        'user_created_at' => '2019-04-05T15:23:55Z'
      }
    end

    before { allow(strategy).to receive(:raw_info).and_return(raw_info) }

    it 'returns correct extra hash' do
      extra = strategy.extra
      expect(extra).to eq(
        raw_info: {
          'id' => 'Wk9PTV9VU0VSX0lE',
          'first_name' => 'Jane',
          'last_name' => 'Dev',
          'display_name' => 'Jane Dev',
          'email' => 'jane.dev@example.com',
          'type' => 2,
          'role_name' => 'Owner',
          'pmi' => 1234567890,
          'use_pmi' => false,
          'personal_meeting_url' => 'https://janedev.zoom.us/j/1234567890?pwd=Wk9PTV9QTUlfUEFTU0NPREU',
          'timezone' => 'America/Denver',
          'verified' => 1,
          'created_at' => '2019-04-05T15:24:32Z',
          'last_login_time' => '2025-03-19T22:42:47Z',
          'last_client_version' => '6.4.0.51205(mac)',
          'pic_url' => 'https://janedev.zoom.us/p/v2/Wk9PTV9QSUNfVVJM/Wk9PTV9QSUNfVVJM',
          'jid' => 'Wk9PTV9VU0VSX0lE@xmpp.zoom.us',
          'group_ids' => [
            'Wk9PTV9HUk9VUF9JRA'
          ],
          'im_group_ids' => [
            'Wk9PTV9HUk9VUF9JRA'
          ],
          'account_id' => 'Wk9PTV9BQ0NPVU5UX0lE',
          'language' => 'en-US',
          'phone_country' => 'US',
          'phone_number' => '+1 1234567890',
          'status' => 'active',
          'company' => 'Zoom',
          'location' => 'Denver, CO, USA',
          'custom_attributes' => [
            {
              'key' => 'Wk9PTV9DVVNUT01fQVRUUklCVVRFX0tFWQ',
              'name' => 'Test',
              'value' => 'set from API'
            }
          ],
          'login_types' => [
            1,
            100
          ],
          'role_id' => '0',
          'account_number' => 12345678,
          'cluster' => 'aw1',
          'phone_numbers' => [
            {
              'country' => 'US',
              'code' => '+1',
              'number' => '1234567890',
              'verified' => false,
              'label' => ''
            }
          ],
          'user_created_at' => '2019-04-05T15:23:55Z'
        }
      )
    end

    it 'prunes empty values' do
      allow(strategy).to receive(:raw_info).and_return({
        'id' => 'Wk9PTV9VU0VSX0lE',
        'first_name' => '',
        'last_name' => '',
        'display_name' => '',
        'email' => '',
        'pic_url' => '',
        'location' => '',
        'verified' => nil,
        'personal_meeting_url' => ''
      })
      extra = strategy.extra
      expect(extra[:raw_info]).to eq({ 'id' => 'Wk9PTV9VU0VSX0lE' })
    end

    context 'when skip_info is true' do
      before { allow(strategy).to receive(:skip_info?).and_return(true) }

      it 'does not include raw_info' do
        extra = strategy.extra
        expect(extra).to eq({})
      end
    end
  end

  describe '#credentials' do
    let(:access_token) do
      instance_double(
        OAuth2::AccessToken,
        token: 'token',
        expires?: true,
        expires_at: 1234567890,
        refresh_token: 'refresh_token'
      )
    end

    before { allow(strategy).to receive(:access_token).and_return(access_token) }

    it 'returns credentials hash' do
      credentials = strategy.credentials
      expect(credentials).to include(
        token: 'token',
        expires: true,
        expires_at: 1234567890,
        refresh_token: 'refresh_token'
      )
    end

    context 'when access token does not expire' do
      let(:access_token) do
        instance_double(
          OAuth2::AccessToken,
          token: 'token',
          expires?: false,
          refresh_token: 'refresh_token'
        )
      end

      it 'does not include expires_at' do
        credentials = strategy.credentials
        expect(credentials).to include(
          token: 'token',
          expires: false,
          refresh_token: 'refresh_token'
        )
        expect(credentials).not_to have_key(:expires_at)
      end
    end

    context 'without refresh token' do
      let(:access_token) do
        instance_double(
          OAuth2::AccessToken,
          token: 'token',
          expires?: true,
          expires_at: 1234567890,
          refresh_token: nil
        )
      end

      it 'does not include refresh_token' do
        credentials = strategy.credentials
        expect(credentials).to include(
          token: 'token',
          expires: true,
          expires_at: 1234567890
        )
        expect(credentials).not_to have_key(:refresh_token)
      end
    end
  end

  describe '#raw_info' do
    let(:access_token) { instance_double(OAuth2::AccessToken, token: 'token') }
    let(:response) { instance_double(OAuth2::Response, parsed: { 'id' => 'Wk9PTV9VU0VSX0lE' }) }

    before do
      allow(access_token).to receive(:get).with('https://api.zoom.us/v2/users/me').and_return(response)
      allow(strategy).to receive(:access_token).and_return(access_token)
    end

    it 'fetches user info from API' do
      expect(strategy.raw_info).to eq({ 'id' => 'Wk9PTV9VU0VSX0lE' })
    end

    it 'memoizes the result' do
      2.times { strategy.raw_info }
      expect(access_token).to have_received(:get).once
    end
  end

  describe '#callback_url' do
    context 'without redirect_uri option' do
      it 'builds callback url from request' do
        allow(strategy).to receive_messages(full_host: 'https://example.com', callback_path: '/auth/zoom_v2/callback')
        expect(strategy.callback_url).to eq('https://example.com/auth/zoom_v2/callback')
      end
    end

    context 'with redirect_uri option' do
      let(:options) { { redirect_uri: 'https://custom.example.com/callback' } }

      it 'uses redirect_uri option' do
        expect(strategy.callback_url).to eq('https://custom.example.com/callback')
      end
    end
  end

  describe '#authorize_params' do
    let(:request) { instance_double(Rack::Request, params: {}) }

    before { allow(strategy).to receive_messages(request: request, session: {}) }

    it 'includes response_type as code' do
      params = strategy.authorize_params
      expect(params[:response_type]).to eq('code')
    end

    context 'with scope in request params' do
      let(:request) { instance_double(Rack::Request, params: { 'scope' => 'user:read:user' }) }

      it 'uses scope from request params' do
        params = strategy.authorize_params
        expect(params[:scope]).to eq('user:read:user')
      end
    end

    context 'with state in request params' do
      let(:request) { instance_double(Rack::Request, params: { 'state' => '12345abcde' }) }

      it 'includes state in params and stores in session' do
        params = strategy.authorize_params
        expect(params[:state]).to eq('12345abcde')
        expect(strategy.session['omniauth.state']).to eq('12345abcde')
      end
    end
  end

  describe '#prune!' do
    it 'removes nil values from hash' do
      hash = { a: 1, b: nil, c: 'test' }
      expect(strategy.send(:prune!, hash)).to eq({ a: 1, c: 'test' })
    end

    it 'removes empty string values from hash' do
      hash = { a: 'value', b: '', c: 'another' }
      expect(strategy.send(:prune!, hash)).to eq({ a: 'value', c: 'another' })
    end

    it 'removes empty array values from hash' do
      hash = { a: [1, 2], b: [], c: ['test'] }
      expect(strategy.send(:prune!, hash)).to eq({ a: [1, 2], c: ['test'] })
    end

    it 'removes empty hash values from hash' do
      hash = { a: { x: 1 }, b: {}, c: { y: 2 } }
      expect(strategy.send(:prune!, hash)).to eq({ a: { x: 1 }, c: { y: 2 } })
    end

    it 'keeps zero values' do
      hash = { a: 0, b: nil, c: 'value' }
      expect(strategy.send(:prune!, hash)).to eq({ a: 0, c: 'value' })
    end

    it 'keeps false values' do
      hash = { a: false, b: nil, c: true }
      expect(strategy.send(:prune!, hash)).to eq({ a: false, c: true })
    end

    it 'handles nested hashes' do
      hash = { a: { x: 1, y: nil, z: '' }, b: { w: nil, x: '', y: [], z: {} }, c: { nested: { value: 'test', empty: nil } } }
      result = strategy.send(:prune!, hash)
      expect(result).to eq({ a: { x: 1 }, c: { nested: { value: 'test' } } })
    end

    it 'modifies the original hash' do
      hash = { a: 1, b: nil, c: 'test' }
      result = strategy.send(:prune!, hash)
      expect(hash.object_id).to eq(result.object_id)
      expect(hash).to eq({ a: 1, c: 'test' })
    end
  end

  describe '#empty?' do
    it 'returns true for nil values' do
      expect(strategy.send(:empty?, nil)).to be(true)
    end

    it 'returns true for empty strings' do
      expect(strategy.send(:empty?, '')).to be(true)
    end

    it 'returns true for empty arrays' do
      expect(strategy.send(:empty?, [])).to be(true)
    end

    it 'returns true for empty hashes' do
      expect(strategy.send(:empty?, {})).to be(true)
    end

    it 'returns false for non-empty strings' do
      expect(strategy.send(:empty?, 'value')).to be(false)
    end

    it 'returns false for non-empty arrays' do
      expect(strategy.send(:empty?, [1, 2, 3])).to be(false)
    end

    it 'returns false for non-empty hashes' do
      expect(strategy.send(:empty?, { key: 'value' })).to be(false)
    end

    it 'returns false for zero values' do
      expect(strategy.send(:empty?, 0)).to be(false)
    end

    it 'returns false for false values' do
      expect(strategy.send(:empty?, false)).to be(false)
    end

    it 'returns false for objects that do not respond to empty?' do
      expect(strategy.send(:empty?, 123)).to be(false)
    end
  end
end
