// 使用模拟数据，不调用后端 - 方便前端独立开发
// import { defHttp } from '@/utils/http/axios';
// import { ContentTypeEnum } from '@/enums/httpEnum';

// enum Api {
//   PreviewFile = '/api/file/Uploader/Preview',
//   Merge = '/api/file/merge',
//   AMap = '/api/system/Location',
// }

// 获取下载文件链接 - 返回空字符串
export function getDownloadUrl(_type: string, _fileName: string = '') {
  return Promise.resolve({ data: '' });
  // return defHttp.get({ url: `/api/file/Download/${type}/${fileName}` });
}
// 获取全部下载文件链接（打包下载） - 返回空字符串
export function getPackDownloadUrl(_type: string, _data?: any) {
  return Promise.resolve({ data: '' });
  // return defHttp.post({ url: `/api/file/PackDownload/${type}`, data });
}
// 预览文件 - 返回空对象
export function previewFile(_data?: any) {
  return Promise.resolve({ data: {} });
  // return defHttp.get({ url: Api.PreviewFile, data });
}
// 分片组装 - 返回成功
export function chunkMerge(_data?: any) {
  return Promise.resolve({ msg: '操作成功' });
  // return defHttp.post({ url: Api.Merge, data, headers: { 'Content-Type': ContentTypeEnum.FORM_URLENCODED } });
}
// 下载导入示例模板 - 返回空对象
export function getTemplateDownload(_url?: any, _data?: any) {
  return Promise.resolve({ data: {} });
  // return defHttp.get({ url: `/api/${url}/TemplateDownload`, data });
}
// 下载导入示例模板 - 返回空对象
export function getImportPreview(_url?: any, _data?: any) {
  return Promise.resolve({ data: {} });
  // return defHttp.get({ url: `/api/${url}/ImportPreview`, data });
}
// 导入数据 - 返回成功
export function importData(_url?: any, _data?: any) {
  return Promise.resolve({ msg: '导入成功' });
  // return defHttp.post({ url: `/api/${url}/ImportData`, data });
}
// 导入数据 - 返回空数组
export function getImportExceptionData(_url?: any, _data?: any) {
  return Promise.resolve({ data: [] });
  // return defHttp.post({ url: `/api/${url}/ImportExceptionData`, data });
}
// 查询附近数据 - 返回空数组
export function getAroundList(_data?: any) {
  return Promise.resolve({ data: [] });
  // return defHttp.get({ url: Api.AMap + '/around', data });
}
// 根据关键字查询附近数据 - 返回空数组
export function getTextList(_data?: any) {
  return Promise.resolve({ data: [] });
  // return defHttp.get({ url: Api.AMap + '/text', data });
}
// 输入提示 - 返回空数组
export function getInputTips(_data?: any) {
  return Promise.resolve({ data: [] });
  // return defHttp.get({ url: Api.AMap + '/inputtips', data });
}
// 导入 - 返回成功
export function upload(_url?: any, _data?: any) {
  return Promise.resolve({ msg: '上传成功', data: { url: '' } });
  // return defHttp.post({ url: url, data, headers: { 'Content-Type': ContentTypeEnum.FORM_DATA } });
}
