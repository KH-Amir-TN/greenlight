import React from 'react';
import { Button } from 'react-bootstrap';
import PropTypes from 'prop-types';
import CreateRoomForm from '../../forms/CreateRoomForm';
import Modal from '../Modal';

export default function CreateRoomModal({ userID, modalButton }) {
  return (
    <Modal
      modalButton={modalButton}
      title="Create New Room"
      body={<CreateRoomForm userID={userID} />}
    />
  );
}

CreateRoomModal.propTypes = {
  modalButton: PropTypes.node,
  userID: PropTypes.number.isRequired,
};

CreateRoomModal.defaultProps = {
  modalButton: <Button variant="primary" className="ms-auto">+ New Room </Button>,
};
