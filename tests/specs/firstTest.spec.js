const assert = require('assert');

describe('Slalom Build page', () => {
  it('should have the right title', () => {
    browser.url('https://www.slalombuild.com/');
    const title = browser.getTitle();
    assert.equal(title, 'Slalom Build: Building modern technology products | BaaS');
  });
});

