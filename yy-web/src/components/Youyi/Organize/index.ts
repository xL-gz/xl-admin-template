import { withInstall } from '@/utils';
import OrganizeSelect from './src/OrganizeSelect.vue';
import OrganizeSelectAsync from './src/OrganizeSelectAsync.vue';
import DepSelect from './src/DepSelect.vue';
import DepSelectAsync from './src/DepSelectAsync.vue';
import PosSelect from './src/PosSelect.vue';
import GroupSelect from './src/GroupSelect.vue';
import RoleSelect from './src/RoleSelect.vue';
import UserSelect from './src/UserSelect.vue';
import UsersSelect from './src/UsersSelect.vue';

const isAsync = true;

export const YouyiOrganizeSelect = withInstall(isAsync ? OrganizeSelectAsync : OrganizeSelect);
export const YouyiDepSelect = withInstall(isAsync ? DepSelectAsync : DepSelect);
export const YouyiPosSelect = withInstall(PosSelect);
export const YouyiGroupSelect = withInstall(GroupSelect);
export const YouyiRoleSelect = withInstall(RoleSelect);
export const YouyiUserSelect = withInstall(UserSelect);
export const YouyiUsersSelect = withInstall(UsersSelect);
