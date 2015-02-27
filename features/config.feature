Feature: config file overrides
  Scenario: uses default from Enviera when no config file present
    When I run `enviera version -t`
    Then the output should match /executor\s+=\s+\(Class\)\s+Enviera::Subcommands::Version/

  Scenario: uses default from configuration file
    Given my SANDBOX_HOME is set to "fake_home"
    When I run `enviera version -t`
    Then the output should match /Loaded config from .*fake_home.\.enviera.config\.yaml/

  Scenario: uses default configuration file supplied by an environment variable
    Given my ENVIERA_CONFIG is set to "enviera_config_file.yaml"
    When I run `enviera version -t`
    Then the output should match /Loaded config from .*enviera_config_file\.yaml/