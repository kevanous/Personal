export default class Page {
    constructor() {
        this.title = 'Slalom Build: Building modern technology products | BaaS';
    }

    open(path) {
        browser.url(path);
    }
}