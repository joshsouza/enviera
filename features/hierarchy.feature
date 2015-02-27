Feature: enviera hierarchy

  In order to see the hiera files applied in a given environment
  As a user or developer using enviera
  I want to use the enviera tool to output hiera files in use in various formats


  Scenario: search hierarchy for a blank environment with default output
    Given my SANDBOX_HOME is set to "fake_home"
    When I run `enviera hierarchy -s '{}'`
    Then the output should match /backend: yaml/
    And the output should match:
    """
    ---\s*
    hierarchy:\s*
    -\s+"?backend.*:\s+yaml"?\s*
    -\s+\./hieradata/common.yaml
    """
    And the output should not match:
    """
    -\s+\./hieradata/dev.yaml
    """
    And the output should not match:
    """
    -\s+\./hieradata/node.yaml
    """

  Scenario: search hierarchy for a blank environment with json output
    Given my SANDBOX_HOME is set to "fake_home"
    When I run `enviera hierarchy -s '{}' -o json`
    Then the output should contain:
    """
    {"hierarchy":[{"backend":"yaml"},"./hieradata/common.yaml"]}
    """

  Scenario: search hierarchy for a dev environment with default output
    Given my SANDBOX_HOME is set to "fake_home"
    When I run `enviera hierarchy -s '{"environment":"dev"}'`
    Then the output should match /backend: yaml/
    And the output should match:
    """
    ---\s*
    hierarchy:\s*
    -\s+"?backend"?:\s+yaml"?\s*
    -\s+\./hieradata/dev.yaml\s*
    -\s+\./hieradata/common.yaml
    """
    And the output should not match:
    """
    -\s+\./hieradata/node.yaml
    """

  Scenario: search hierarchy for a dev environment with json output
    Given my SANDBOX_HOME is set to "fake_home"
    When I run `enviera hierarchy -s '{"environment":"dev"}' -o json`
    Then the output should contain:
    """
    {"hierarchy":[{"backend":"yaml"},"./hieradata/dev.yaml","./hieradata/common.yaml"]}
    """


  Scenario: search hierarchy for a node environment with json output
    Given my SANDBOX_HOME is set to "fake_home"
    When I run `enviera hierarchy -s '{"environment":"dev","fqdn":"node.localhost"}' -o json`
    Then the output should contain:
    """
    {"hierarchy":[{"backend":"yaml"},"./hieradata/node.localhost.yaml","./hieradata/dev.yaml","./hieradata/common.yaml"]}
    """
