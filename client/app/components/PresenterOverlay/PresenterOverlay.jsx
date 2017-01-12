import styles from './_PresenterOverlay.scss';

import React, { PropTypes } from 'react';
import PresenterControls from '../PresenterControls/PresenterControls';
import ConnectionsDisplay from '../ConnectionsDisplay/ConnectionsDisplay';
import Notes from '../Notes/Notes';
import SlidePreview from '../SlidePreview/SlidePreview';
import SlideActions from '../../actions/SlideActions';

export default class PresenterOverlay extends React.Component {

  constructor() {
    super();
    this.state = {};
  }

  componentDidMount() {
    window.addEventListener('keydown', this.handleKeyPress, false);
  }

  componentWillUnmount() {
    window.removeEventListener('keydown', this.handleKeyPress, false);
  }

  nextSlide = () => {
    SlideActions.nextSlide(this.props.channel);
  }

  reloadDeck = () => {
    SlideActions.reloadDeck(this.props.channel);
  }

  prevSlide = () => {
    SlideActions.prevSlide(this.props.channel);
  }

  toggleControls = () => {
    this.setState({showControls: !this.state.showControls});
  }

  handleKeyPress = (e) => {
    console.log(e);
    switch(e.keyCode) {
      case 33: // Page up
      case 37: // Left arrow
        this.prevSlide();
        break;
      case 32: // Space
      case 34: // Page down
      case 39: // Right arrow
        this.nextSlide();
        break
      case 27:  // Escape
        break;
      case 67: // c
        this.toggleControls();
        break;
      case 116: // F5
        // Anything on "present" button?
        break;
      case 190: // Period
        this.reloadDeck();
        break;
      default:
    }
  }

  static propTypes = {
    slide: PropTypes.object.isRequired,
    channel: PropTypes.object.isRequired,
    isPresenter: PropTypes.bool.isRequired
  }

  render() {
    let { slide, channel } = this.props;
    if (this.props.isPresenter) {
      if (this.state.showControls) {
        return (
          <div className={styles.overlay}>
            <PresenterControls channel={channel} />
            <ConnectionsDisplay />
            <Notes notes={slide.notes} />
            <SlidePreview channel={channel} slide={slide.next} />
          </div>
        );
      } else {
        return (<div></div>);
      }
    } else {
      return false;
    }
  }

}
