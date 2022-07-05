import React, { useState } from 'react';
import {
  Row, Col, Stack,
} from 'react-bootstrap';
import Spinner from '../shared/stylings/Spinner';
import RoomCard from './RoomCard';
import useRooms from '../../hooks/queries/rooms/useRooms';
import RoomPlaceHolder from './RoomPlaceHolder';
import SearchBar from '../shared/SearchBar';
import { useAuth } from '../../contexts/auth/AuthProvider';
import CreateRoomModal from '../shared/modals/CreateRoomModal';

export default function RoomsList() {
  const { id: userID } = useAuth();
  const { isLoading, data: rooms } = useRooms(userID);
  const [search, setSearch] = useState('');
  if (isLoading) return <Spinner />;

  return (
    <div className="wide-background full-height-rooms">
      <Stack direction="horizontal" className="w-100 mt-5">
        <div>
          <SearchBar id="rooms-search" setSearch={setSearch} />
        </div>
        <CreateRoomModal userID={userID} />
      </Stack>
      <Row md={4} className="g-4 pb-4 mt-4">
        {
          rooms.filter((room) => {
            if (room.name.toLowerCase().includes(search.toLowerCase())) {
              return room;
            }
            return false;
          }).map((room) => (
            <Col key={room.friendly_id} className="mt-0 mb-4">
              {(room.optimistic && <RoomPlaceHolder />) || <RoomCard room={room} />}
            </Col>
          ))
        }
      </Row>
    </div>
  );
}
