import React from 'react';
import renderer from 'react-test-renderer';
import RoomsList from "../../components/rooms/RoomsList";

jest.mock('react-router-dom')
jest.mock('../../hooks/queries/rooms/useRooms')

describe('Room (Snapshot)', () => {
  it('RoomsList renders list of rooms', () => {
    const component = renderer.create(<RoomsList />);
    const json = component.toJSON();
    expect(json).toMatchSnapshot();
  });
});
