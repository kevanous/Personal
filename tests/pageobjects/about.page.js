import Page from './page';

class AboutPage extends Page {

  get heading() { return $('span=About'); }

}

export default new AboutPage();