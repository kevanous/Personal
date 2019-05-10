import { expect } from 'chai';
import MainPage from './../pageobjects/main.page';
import NavigationPage from './../pageobjects/navigation.page';
import AboutPage from './../pageobjects/about.page';

describe('About page', () => {
  before(() => {
    MainPage.open();
    NavigationPage.hamburgerMenuClick();
    NavigationPage.aboutLinkClick();
  });

  it('should be displayed', () => {
    // browser.debug();
    expect(AboutPage.heading.isDisplayed()).to.be.true;
  });
});