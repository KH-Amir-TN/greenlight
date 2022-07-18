import { useQuery } from 'react-query';
import axios from '../../../../helpers/Axios';

export default function useSiteSetttings() {
  return useQuery(
    'getSiteSettings',
    () => axios.get('/site_settings.json').then((resp) => resp.data.data),
  );
}
