// BigBlueButton open source conferencing system - http://www.bigbluebutton.org/.
//
// Copyright (c) 2022 BigBlueButton Inc. and by respective authors (see below).
//
// This program is free software; you can redistribute it and/or modify it under the
// terms of the GNU Lesser General Public License as published by the Free Software
// Foundation; either version 3.0 of the License, or (at your option) any later
// version.
//
// Greenlight is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
// PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License along
// with Greenlight; if not, see <http://www.gnu.org/licenses/>.

/* eslint-disable consistent-return */
import React, { useState } from 'react';
import {
  Card, Row, Tab, Tabs,
} from 'react-bootstrap';
import { useTranslation } from 'react-i18next';
import JoinCard from './JoinCard';
import Logo from '../../../shared_components/Logo';
import PublicRecordingsCard from './PublicRecordingsCard';

export default function RoomJoin() {
  const { t } = useTranslation();
  const [selected, select] = useState('');

  return (
    <div className="vertical-center">
      <Row className="text-center pb-4">
        <Logo />
      </Row>
      <Row>
        <Card className={`${selected === 'recordings' ? '' : 'col-md-6'} mx-auto p-0 border-0 card-shadow`}>
          <Tabs defaultActiveKey="join" onSelect={select} unmountOnExit>
            <Tab eventKey="join" title={t('join')}>
              <JoinCard />
            </Tab>
            <Tab eventKey="recordings" title={t('recording.recordings')}>
              <PublicRecordingsCard />
            </Tab>
          </Tabs>
        </Card>
      </Row>
    </div>
  );
}
