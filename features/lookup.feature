Feature: enviera lookup

  In order to see the hiera values available in a given environment
  As a user or developer using enviera
  I want to use the enviera tool to output hiera data in various formats


  Scenario: lookup a blank environment with default output
    Given my SANDBOX_HOME is set to "fake_home"
    When I run `enviera lookup -s '{}'`
    Then the output should match /config: common/

  Scenario: lookup a dev environment with default output
    Given my SANDBOX_HOME is set to "fake_home"
    When I run `enviera lookup -s '{"environment":"dev"}'`
    Then the output should match /config: dev/

  Scenario: lookup a dev environment with json output
    Given my SANDBOX_HOME is set to "fake_home"
    When I run `enviera lookup -s '{"environment":"dev"}' -o json`
    Then the output should match /\{.*"config":\s*"dev".*\}/

  Scenario: lookup a dev environment with json output and 'classes' merged
    Given my SANDBOX_HOME is set to "fake_home"
    When I run `enviera lookup -s '{"environment":"dev"}' -o json -m "classes"`
    Then the output should match /\{.*"config":\s*"dev".*\}/
    Then the output should match /\{.*"classes":\s*\["dev","common"\].*\}/