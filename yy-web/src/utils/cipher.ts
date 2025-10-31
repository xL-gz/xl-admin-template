import { encrypt, decrypt } from 'crypto-js/aes';
import CryptoJS from 'crypto-js/crypto-js'
import { parse } from 'crypto-js/enc-utf8';
import pkcs7 from 'crypto-js/pad-pkcs7';
import ECB from 'crypto-js/mode-ecb';
import md5 from 'crypto-js/md5';
import UTF8 from 'crypto-js/enc-utf8';
import Base64 from 'crypto-js/enc-base64';
import Hex from 'crypto-js/enc-hex';
import { useGlobSetting } from '@/hooks/setting';
 import { ec } from 'elliptic';

import JSEncrypt from 'jsencrypt';

const globSetting = useGlobSetting();

export interface EncryptionParams {
  key: string;
  iv: string;
  beginPubKey:string;
  beginPriKey:string;
  endPriKey:string;
  useHex: boolean;
  // option:Map<sizeEnum, number>;
}

export class AesEncryption {
  private key;
  private iv;
  private useHex = false;

  private aesIvKey;
  private option;
  private rsaKeySize='1024';
  /*
   公钥转换截取 字符串
   */
  private beginPubKey="3056301006072a8648ce3d020106052b8104000a034200"

  /*
   私钥转换截取 字符串 前缀
   */
  private  beginPriKey="30740201010420"
  /*
   私钥转换截取 字符串 后缀
   */
  private  endPriKey="A00706052B8104000AA144034200"
  private  ecdh;/*DH 对象*/
  getAesIvKey(){
    if(!this.aesIvKey){
      let ivArr=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
      let iv=this.getStrFromBytes(ivArr);
      this.aesIvKey=UTF8.parse(iv);
    }
    return this.aesIvKey;
  }
  constructor(opt: Partial<EncryptionParams> = {}) {
    const { key = globSetting.cipherKey, iv, useHex } = opt;
    if (key) this.key = parse(key);
    if (iv) this.iv = parse(iv);
    if (useHex) this.useHex = !!useHex;
  }

  get getOptions() {
    return {
      mode: ECB,
      padding: pkcs7,
      iv: this.iv,
    };
  }
   getYyOptions(ivKey) {
    if(!this.option) {

      this.option= {
        mode: CryptoJS.mode.CBC,
        padding: pkcs7,
        iv: ivKey,
      };
    }
    return this.option;
  }
  encryptByAES(cipherText: string) {
    const result = encrypt(cipherText, this.key, this.getOptions).toString();
    return this.useHex ? Hex.stringify(Base64.parse(result)) : result;
  }
  encryptAES(value,key){
    console.log("9");
    return this.encrypt1(value,key);
  }
  decryptByAES(cipherText: string) {
    const realCipherText = this.useHex ? Base64.stringify(Hex.parse(cipherText)) : cipherText;
    return decrypt(realCipherText, this.key, this.getOptions).toString(UTF8);
  }
  encrypt1 (value, key) {
    return encrypt(value, key, this.getYyOptions(this.getAesIvKey()));
  }
  /*
 构建登陆密码
 pwd 密文密码
 */
  buildLoginPassword(pwd){
    let md5pwd=md5(pwd);
    let md5Str=Base64.stringify(md5pwd);
    let encryptAES=this.encryptAES(Base64.parse(md5Str),md5pwd);
    let md5Aes=md5(encryptAES.ciphertext);
    let encode =Hex.stringify(md5Aes);
    return encode;
  }

  encryptAES_StrToStr_test(value,key){
    let result= this.encrypt1(value,key);
    return Base64.stringify(result.ciphertext);
  }
  encryptMac(value,key){
    return CryptoJS.HmacMD5(value, key);
  }
  encryptMacToBase64(value,key){
    let mac= this.encryptMac(value, key);
    return Base64.stringify(mac);
  }
  /*
 字节数组转换为字符串
 */
  getStrFromBytes (arr) {
    let r = "";
    /* for (let i in arr) {
     r += String.fromCharCode(i);
     }*/
    for(let i=0;i<arr.length;i++){
      r += String.fromCharCode(arr[i]);
    }
    //console.log(r);
    return r;
  }
  /*
   key 公钥 or 私钥
   key 不传值 则创建一对新的密钥对
   */
  generatedRSAKey(key){
    /*创建 RSA 密钥对*/
    let rsaKeyPair = new JSEncrypt({default_key_size:this.rsaKeySize});
    if(!key){
      rsaKeyPair.getKey();
    }else {
      rsaKeyPair.setKey(key);
    }
    return rsaKeyPair;
  }
  /*
 创建DH 密钥对
 */
  genDHKeyPair(){
    return this.genKeyPair();
  }
  /*
  创建DH 密钥对
  */
  genKeyPair(){
    return  this.getECDH().genKeyPair();
  }
  getECDH(){
    if(!this.ecdh){
      this.ecdh = new ec('secp256k1');
    }

    return this.ecdh;
  }
  /*
 js DH私钥对象转换为 服务器 base64 私钥字符串
 keyPair  js 密钥对象
 */
  encryptDHPrivateKey(keyPair){
    return this.encryptPrivateKey(keyPair);
  }
  /*
 js DH私钥对象转换为 服务器 base64 私钥字符串
 keyPair  js 密钥对象
 */
  encryptPrivateKey(keyPair){
    let pri=keyPair.getPrivate('hex');
    let pub=keyPair.getPublic('hex');
    let priHexStr= this.beginPriKey+pri+this.endPriKey+pub;
    let priByte=Hex.parse(priHexStr);
    return Base64.stringify(priByte);
  }
  /*
   js DH公钥对象转换为 服务器 base64 公钥字符串
   pub  js DH公钥对象
   */
  encryptDHPublicKey(pub){
    return this.encryptPublicKey(pub);
  }
  /*
   js DH公钥对象转换为 服务器 base64 公钥字符串
   pub  js DH公钥对象
   */
  encryptPublicKey(pub){
    let pubHexStr= this.beginPubKey+pub.encode('hex');
    let pubByte=Hex.parse(pubHexStr);
    return Base64.stringify(pubByte);
  }
  /**
   * 创建RSA和DH的公私钥方法
   * @param obj.repassword 明文密码
   */
  createRSAandDHSecretKey (obj){
    console.log("createRSAandDHSecretKey :"+JSON.stringify(obj));
    // rsa 秘钥对
    let keyPrair = this.generatedRSAKey(null);
    let rsaPrivateKey = keyPrair.getPrivateKeyB64();
    let rsaPublicKey = keyPrair.getPublicKeyB64();
    console.log("rsa 私钥 ："+rsaPrivateKey);
    rsaPrivateKey = this.encryptAES_StrToStr_test(Base64.parse(rsaPrivateKey),md5(obj.repassword));

    obj.rsaPublicKey = rsaPublicKey;
    obj.rsaPrivateKey = rsaPrivateKey;
    // dh秘钥对
    let ecdh = this.genDHKeyPair();
    console.log("1：");
    let dhPrivateKey=this.encryptDHPrivateKey(ecdh);
    let dhPublicKey=this.encryptDHPublicKey(ecdh.getPublic());
    console.log("regedit : "+dhPrivateKey);
    console.log("webpub : "+dhPublicKey);
    dhPrivateKey = this.encryptAES_StrToStr_test(Base64.parse(dhPrivateKey), md5(obj.repassword));
    console.log("webpri :"+dhPrivateKey);
    obj.dhPublicKey = dhPublicKey;
    obj.dhPrivateKey = dhPrivateKey;
    delete obj.repassword;// 明文密码
    return obj;
  }

  resetPasswordV1Param (obj){
    console.log("resetPasswordV1Param obj : "+JSON.stringify(obj));
    let newPassword = this.buildLoginPassword(obj.repassword);// 新密码
    console.log("newPassword : "+newPassword);
    let code = Base64.parse(newPassword).toString().substring(0,32);// 24 toString = 16进制48*2；16
    let ward = Hex.parse(code);
    console.log("ward : "+code);
    console.log("apiKey : "+localStorage.getItem("apiKey"));
    let byteAesPwdTest = this.encryptAES_StrToStr_test(UTF8.parse("212i919292901"),ward);
    console.log("key :"+byteAesPwdTest);
    obj.mac = this.encryptMacToBase64(Base64.parse(byteAesPwdTest),UTF8.parse(obj.telephone));
    console.log("mac :"+obj.mac);
    obj.newPassword = newPassword;
    obj = this.createRSAandDHSecretKey(obj);
    console.log("11111111  "+obj.newPassword);
    return obj;
  }
}

export function encryptByBase64(cipherText: string) {
  return UTF8.parse(cipherText).toString(Base64);
}

export function decodeByBase64(cipherText: string) {
  return Base64.parse(cipherText).toString(UTF8);
}

export function encryptByMd5(password: string) {
  return md5(password).toString();
}


