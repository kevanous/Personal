import Page from './page';

class MainPage extends Page {

  get landingVideo() { return $('.main section video'); }
  get acceptCookiesButton() { return $('.accept-cookies-button'); }

  open() {
    super.open('');
    this.landingVideo.waitForDisplayed();
  }

  acceptCookiesClick() {
    this.acceptCookiesButton.click();
  }

}

export default new MainPage();