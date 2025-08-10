# OmniauthZoomV2

[![License](https://img.shields.io/github/license/cadenza-tech/omniauth-zoom-v2?label=License&labelColor=343B42&color=blue)](https://github.com/cadenza-tech/omniauth-zoom-v2/blob/main/LICENSE.txt) [![Tag](https://img.shields.io/github/tag/cadenza-tech/omniauth-zoom-v2?label=Tag&logo=github&labelColor=343B42&color=2EBC4F)](https://github.com/cadenza-tech/omniauth-zoom-v2/blob/main/CHANGELOG.md) [![Release](https://github.com/cadenza-tech/omniauth-zoom-v2/actions/workflows/release.yml/badge.svg)](https://github.com/cadenza-tech/omniauth-zoom-v2/actions?query=workflow%3Arelease) [![Test](https://github.com/cadenza-tech/omniauth-zoom-v2/actions/workflows/test.yml/badge.svg)](https://github.com/cadenza-tech/omniauth-zoom-v2/actions?query=workflow%3Atest) [![Lint](https://github.com/cadenza-tech/omniauth-zoom-v2/actions/workflows/lint.yml/badge.svg)](https://github.com/cadenza-tech/omniauth-zoom-v2/actions?query=workflow%3Alint)

Zoom strategy for OmniAuth.

- [Installation](#installation)
- [Usage](#usage)
  - [Rails Configuration with Devise](#rails-configuration-with-devise)
  - [Configuration Options](#configuration-options)
  - [Auth Hash](#auth-hash)
- [Changelog](#changelog)
- [Contributing](#contributing)
- [License](#license)
- [Code of Conduct](#code-of-conduct)
- [Sponsor](#sponsor)

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add omniauth-zoom-v2
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install omniauth-zoom-v2
```

## Usage

### Rails Configuration with Devise

Add the following to `config/initializers/devise.rb`:

```ruby
# config/initializers/devise.rb
Devise.setup do |config|
  config.omniauth :zoom_v2, ENV['ZOOM_CLIENT_ID'], ENV['ZOOM_CLIENT_SECRET']
end
```

Add the OmniAuth callbacks routes to `config/routes.rb`:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
end
```

Add the OmniAuth configuration to your Devise model:

```ruby
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:zoom_v2]
end
```

### Configuration Options

You can configure several options:

```ruby
# config/initializers/devise.rb
Devise.setup do |config|
  config.omniauth :zoom_v2, ENV['ZOOM_CLIENT_ID'], ENV['ZOOM_CLIENT_SECRET'],
    {
      scope: 'user:read:user', # Specify OAuth scopes
      callback_path: '/custom/zoom_v2/callback', # Custom callback path
    }
end
```

### Auth Hash

After successful authentication, the auth hash will be available in `request.env['omniauth.auth']`:

```ruby
{
  provider: 'zoom_v2',
  uid: 'Wk9PTV9VU0VSX0lE',
  info: {
    name: 'Jane Dev',
    nickname: 'Jane Dev',
    email: 'jane.dev@example.com',
    image: 'https://janedev.zoom.us/p/v2/Wk9PTV9QSUNfVVJM/Wk9PTV9QSUNfVVJM',
    location: 'Denver, CO, USA',
    verified: 1,
    urls: {
      zoom: 'https://janedev.zoom.us/j/1234567890?pwd=Wk9PTV9QTUlfUEFTU0NPREU'
    }
  },
  credentials: {
    token: 'bNl4YEFPI/eyJzdiI6IjAwMDAwMiIsImFsZyI6IkhTNTEyIiwidiI6IjIuMCIsImtpZCI6IlpPT01fS0lEIn0',
    expires: true,
    expires_at: 1504169092,
    refresh_token: 'eyJzdiI6IjAwMDAwMiIsImFsZyI6IkhTNTEyIiwidiI6IjIuMCIsImtpZCI6IlpPT01fS0lEIn0'
  },
  extra: {
    raw_info: {
      id: 'Wk9PTV9VU0VSX0lE',
      first_name: 'Jane',
      last_name: 'Dev',
      display_name: 'Jane Dev',
      email: 'jane.dev@example.com',
      type: 2,
      role_name: 'Owner',
      pmi: 1234567890,
      use_pmi: false,
      personal_meeting_url: 'https://janedev.zoom.us/j/1234567890?pwd=Wk9PTV9QTUlfUEFTU0NPREU',
      timezone: 'America/Denver',
      verified: 1,
      dept: '',
      created_at: '2019-04-05T15:24:32Z',
      last_login_time: '2025-03-19T22:42:47Z',
      last_client_version: '6.4.0.51205(mac)',
      pic_url: 'https://janedev.zoom.us/p/v2/Wk9PTV9QSUNfVVJM/Wk9PTV9QSUNfVVJM',
      cms_user_id: '',
      jid: 'Wk9PTV9VU0VSX0lE@xmpp.zoom.us',
      group_ids: [
        'Wk9PTV9HUk9VUF9JRA'
      ],
      im_group_ids: [
        'Wk9PTV9HUk9VUF9JRA'
      ],
      account_id: 'Wk9PTV9BQ0NPVU5UX0lE',
      language: 'en-US',
      phone_country: 'US',
      phone_number: '+1 1234567890',
      status: 'active',
      job_title: '',
      cost_center: '',
      company: 'Zoom',
      location: 'Denver, CO, USA',
      custom_attributes: [
        {
          key: 'Wk9PTV9DVVNUT01fQVRUUklCVVRFX0tFWQ',
          name: 'Test',
          value: 'set from API'
        }
      ],
      login_types: [
        1,
        100
      ],
      role_id: '0',
      account_number: 12345678,
      cluster: 'aw1',
      phone_numbers: [
        {
          country: 'US',
          code: '+1',
          number: '1234567890',
          verified: false,
          label: ''
        }
      ],
      user_created_at: '2019-04-05T15:23:55Z'
    }
  }
}
```

## Changelog

See [CHANGELOG.md](https://github.com/cadenza-tech/omniauth-zoom-v2/blob/main/CHANGELOG.md).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cadenza-tech/omniauth-zoom-v2. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/cadenza-tech/omniauth-zoom-v2/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://github.com/cadenza-tech/omniauth-zoom-v2/blob/main/LICENSE.txt).

## Code of Conduct

Everyone interacting in the OmniauthZoomV2 project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/cadenza-tech/omniauth-zoom-v2/blob/main/CODE_OF_CONDUCT.md).

## Sponsor

You can sponsor this project on [Patreon](https://patreon.com/CadenzaTech).
