import uuid from 'uuid';

class Player {
  uuid;

  name;

  answers;

  points;

  active;

  constructor(name) {
    this.uuid = uuid.v4();
    this.name = name;
    this.points = 0;
    this.active = true;
  }

  isActive() {
    return this.active;
  }

  setActive(active) {
    this.active = active;
  }

  addButtons(buttons) {
    buttons.forEach(button => {
      this.answers.push(button);
    });
  }

  removeButtons(buttons) {
    const removeRandom = typeof buttons === 'boolean';
    const pos = removeRandom ? Math.floor(Math.random() * this.answers.length) : -1;
    this.answers = this.answers.filter((button, i) => {
      if (removeRandom) {
        if (i === pos) {
          return false;
        }
      }
      if (typeof buttons.length === 'undefined') {
        return button.id !== buttons.id;
      }
      for (let i = 0; i < buttons.length; i++) {
        if (buttons[i].id === button.id) {
          return false;
        }
      }
      return true;
    });
  }
}

export default Player;
