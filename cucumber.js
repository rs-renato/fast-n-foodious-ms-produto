module.exports = {
  default: `--format-options '{"snippetInterface": "synchronous"}'`,
  // GitHub Actions specific configuration
  format: ['pretty', 'json:./reports/cucumber-report.json'],
};
