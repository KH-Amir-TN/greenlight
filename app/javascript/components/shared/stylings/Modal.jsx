import React, { useState } from 'react';
import { Modal as BootstrapModal } from 'react-bootstrap';
import PropTypes from 'prop-types';

export default function Modal({
  openElement, title, children, footer
}) {
  const [show, setShow] = useState(false);

  const handleClose = () => setShow(false);
  const handleShow = () => setShow(true);

  const Footer = React.cloneElement(footer, { handleClose });
  const OpenElement = React.cloneElement(openElement, { onClick: handleShow });

  return (
    <>
      {OpenElement}
      <BootstrapModal className="text-center" show={show} onHide={handleClose}>
        <BootstrapModal.Header className="border-0" closeButton />
        <BootstrapModal.Title>{title}</BootstrapModal.Title>
        <BootstrapModal.Body>{children}</BootstrapModal.Body>
        <BootstrapModal.Footer>
          {Footer}
        </BootstrapModal.Footer>
      </BootstrapModal>
    </>
  );
}

Modal.propTypes = {
  title: PropTypes.string.isRequired,
  footer: PropTypes.element.isRequired,
  openElement: PropTypes.element.isRequired,
  children: PropTypes.node,
};
