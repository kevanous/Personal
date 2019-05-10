import Page from './page';
import AboutPage from './about.page';

class NavigationPage extends Page {

  get hamburgerMenuButton() { return $('.nav-icon'); }
  get navLinksArray() { return $$('.main-nav .px2 ul li'); }
  get aboutLink() { return $('a=About'); }

  hamburgerMenuClick() {
    this.hamburgerMenuButton.click();
    this.aboutLink.waitForDisplayed();
  }

  aboutLinkClick() {
    this.aboutLink.click();
    AboutPage.heading.waitForDisplayed();
  }

}

export default new NavigationPage();