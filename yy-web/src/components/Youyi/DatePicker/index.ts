import { withInstall } from '@/utils';
import DatePicker from './src/DatePicker.vue';
import DateRange from './src/DateRange.vue';
import TimePicker from './src/TimePicker.vue';
import TimeRange from './src/TimeRange.vue';

export const YouyiDatePicker = withInstall(DatePicker);
export const YouyiDateRange = withInstall(DateRange);
export const YouyiTimePicker = withInstall(TimePicker);
export const YouyiTimeRange = withInstall(TimeRange);
