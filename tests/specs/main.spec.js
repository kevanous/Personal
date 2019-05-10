import { expect } from 'chai';
import MainPage from './../pageobjects/main.page';
import NavigationPage from './../pageobjects/navigation.page';

describe('Slalom Build page', () => {
  it('should have the right title', () => {
    MainPage.open();
    const title = browser.getTitle();
    expect(title).to.equal('Slalom Build: Building modern technology products | BaaS');
  });

  it('should display Accept Cookie button', () => {
    expect(MainPage.acceptCookiesButton.isDisplayed()).to.be.true;
  });

  it('should display Hamburger Menu button', () => {
    expect(NavigationPage.hamburgerMenuButton.isDisplayed()).to.be.true;
  });

  it('should display 7 menu items', () => {
    NavigationPage.hamburgerMenuClick();
    const navLinksCount = NavigationPage.navLinksArray.length;
    expect(navLinksCount).to.equal(7);
  });
});