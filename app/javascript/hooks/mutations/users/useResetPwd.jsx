import { useMutation } from 'react-query';
import { useNavigate } from 'react-router-dom';
import axios, { ENDPOINTS } from '../../../helpers/Axios';

export default function useResetPwd() {
  const resetPwd = (data) => axios.post(ENDPOINTS.reset_password, data);
  const navigate = useNavigate();
  const mutation = useMutation(
    resetPwd,
    { // Mutation config.
      mutationKey: ENDPOINTS.reset_password,
      onError: (error) => { console.error('Error:', error.message); navigate('/'); },
      onSuccess: (data) => {
        console.info(data);
        navigate('/signin');
      },
    },
  );
  const onSubmit = (user) => mutation.mutateAsync({ user }).catch(/* Prevents the promise exception from bubbling */() => { });
  return { onSubmit, ...mutation };
}
