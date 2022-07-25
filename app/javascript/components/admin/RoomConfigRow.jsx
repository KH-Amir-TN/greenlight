import React from 'react';
import PropTypes from 'prop-types';
import {
  Row, Stack, Form as BootStrapForm,
} from 'react-bootstrap';
import { useForm } from 'react-hook-form';
import FormControl from '../forms/FormControl';
import Form from '../forms/Form';
import { RoomConfigFormConfig, RoomConfigFormFields } from '../../helpers/forms/RoomConfigFormHelpers';

export default function RoomConfigRow({
  value, title, subtitle, mutation: useUpdateRoomConfig,
}) {
  const { defaultValues } = RoomConfigFormConfig;
  defaultValues.value = value;
  const updateRoomConfig = useUpdateRoomConfig();
  const methods = useForm(RoomConfigFormConfig);
  const fields = RoomConfigFormFields;

  return (
    <Row>
      <Stack className="my-2" direction="horizontal">
        <Stack>
          <strong> {title} </strong>
          <span className="text-muted"> {subtitle} </span>
        </Stack>
        <Form methods={methods} onChange={methods.handleSubmit(updateRoomConfig.mutate)}>
          <FormControl control={BootStrapForm.Select} field={fields.value} disabled={updateRoomConfig.isLoading}>
            <option value="optional">Optional</option>
            <option value="false">Disabled</option>
            <option value="true">Enabled</option>
          </FormControl>
        </Form>
      </Stack>
    </Row>
  );
}

RoomConfigRow.propTypes = {
  title: PropTypes.string.isRequired,
  subtitle: PropTypes.string.isRequired,
  mutation: PropTypes.func.isRequired,
  value: PropTypes.string.isRequired,
};
