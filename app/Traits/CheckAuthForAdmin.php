<?php
namespace App\Traits;

use App\Models\Admin;
use App\Models\Roll;
use App\Models\Stores;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Http;
trait CheckAuthForAdmin {

    /**
     * @param Request $request
     * @return $this|false|string
     */
    public function authAdmin(Request $request) {
        $validator = Validator::make($request->all(), [
            'phone' => 'required|string',
            'password' => 'required|string',
            'country' => 'required|integer',
        ]);
        if ($validator->fails()) {
            //error 400 bad request

            return array("status"=>false,"code"=>400,'message'=>$validator->errors(),"error"=>5555);
        }
        else{
            $admin=Admin::where('phone',$request->phone)->first();
            if(empty($admin))
            {
                // return false;
                return array("status"=>false,"message"=>"المستخدم غير مسجل","code"=>400);
            }
            if($admin->password==$request->password)
            {
                if($admin->roll->name=='admin' ||$admin->roll->name=='country_manager')
                {
                    // return true;
                    return array("status"=>true,"rolls_id"=>$admin->roll->id,
                    "country"=>$admin->country);
                }
                else{
                    return array("status"=>false,"message"=>"you do not have permission","code"=>401);
                }
            }
            else{
                //if the admin are not auth
                return array("status"=>false,"message"=>"you are not authenticated","code"=>401);
            }
        }
            return array("status"=>false,"message"=>"you are not authenticated","code"=>401);
}
public function registerOrNot(Request $request)
{
    $validator = Validator::make($request->all(), [
        'phone' => 'required|string',
        'password' => 'required|string',
    ]);
    if ($validator->fails()) {
        //error 400 bad request

        return array("status"=>false,"code"=>400,'message'=>$validator->errors(),"error"=>5555);
    }
    else{
        $admin=Admin::where('phone',$request->phone)->first();
        if(empty($admin))
        {
            // return false;
            return array("status"=>false,"message"=>"المستخدم غير مسجل","code"=>400);
        }
        if($admin->password==$request->password)
        {
                return array("status"=>true,'rolls_id'=>$admin->roll->id,
                'rolls_name'=>$admin->roll->name,
                'admin_id'=>$admin->id,
                'country'=>$admin->country);
        }
        else{
            //if the admin are not auth
            return array("status"=>false,"message"=>"you are not authenticated","code"=>401);
        }
    }
}

public function authStore(Request $request)
{
    $validator = Validator::make($request->all(),[
        'phone' => 'required|string',
        'password' => 'required|string',
    ]);
    if ($validator->fails()) {
        //error 400 bad request

        return array("status"=>false,"code"=>400,'message'=>$validator->errors(),"error"=>5555);
    }
    else{
        $stores=Stores::where('phone',$request->phone)->first();
        if(empty($stores))
        {
            // return false;
            return array("status"=>false,"message"=>"المستخدم غير مسجل","code"=>400);
        }
        if($stores->password==$request->password)
        {
            return array("status"=>true,"store_country"=>$stores->country,"store_id"=>$stores->id); 
        }
        else
        {
            return array("status"=>false,"message"=>"المستخدم غير مسجل","code"=>400);
        }
    }
}

//خاص بالمشرفين في الدولة المعينة
public function sendnotifcation($token,$title,$body)
{
    //you can uncommand this code to use firebase messaging

    // $response = Http::withHeaders([
    //     'Authorization' => 'Bearer '.'AAAAyH4w4Y0:APA91bER2Z2S8Rqe3xhLQ1LKEpR3byjExnHxl4Un3UWezbRM6Cuxzoy3BMnHTE4tcZEOOJNjhteYLSEYZO8M7PQDFuqQF9QrxIpziCHfOuj6UF_RxGKB3TcWATwkhQUqBsItqP8hua9',
    //     'Content-Type' => 'application/json',
    // ])
    //     ->post('https://fcm.googleapis.com/fcm/send', [
    //         'to' => $token,
    //         'notification' => [
    //             'title' => $title,
    //             'body' => $body,
    //             'mutable_content' => true,
    //             'sound' => 'Tri-tone',
    //         ],
    //         'data' => [
    //             'img' => "",
    //         ],
    //     ]);

    // return $response->body();
    return "nothing";
}
public function sendnotifcation_toTopic($title,$body,$img,$country)
{
    //من اجل ارسال الاعلانات وغيرها الى جميع المستخدمين
    //you can uncommand this code to use firebase messaging

    // $topic='yemeni_notification';
    // if($country==1)
    // {
    //     $topic='saudi_notification';

    // }
    // $response = Http::withHeaders([
    //     'Authorization' => 'Bearer '.'AAAAyH4w4Y0:APA91bER2Z2S8Rqe3xhLQ1LKEpR3byjExnHxl4Un3UWezbRM6Cuxzoy3BMnHTE4tcZEOOJNjhteYLSEYZO8M7PQDFuqQF9QrxIpziCHfOuj6UF_RxGKB3TcWATwkhQUqBsItqP8hua9',
    //     'Content-Type' => 'application/json',
    // ])
    //     ->post('https://fcm.googleapis.com/fcm/send', [
    //         'to' => '/topics/'.$topic,
    //         'notification' => [
    //             'title' => $title,
    //             'body' => $body,
    //             'mutable_content' => true,
    //             'sound' => 'Tri-tone',
    //         ],
    //         'data' => [
    //             'img' => $img,
    //         ],
    //     ]);
    // return $response->body();
    return "nothing";
}
public function deliveyInCountryTopic($title,$body,$country)
{
    //من اجل ارسال الطلبات قيد التوصيل الى الموصلين في الدولة
    //you can uncommand this code to use firebase messaging
    // $topic='yemeni_delivery';
    // if($country==0)
    // {
    //     $topic='yemeni_delivery';
    // }
    // elseif($country==1){
    // $topic='saudi_delivery';
    // }
    // $response = Http::withHeaders([
    //     'Authorization' => 'Bearer '.'AAAAyH4w4Y0:APA91bER2Z2S8Rqe3xhLQ1LKEpR3byjExnHxl4Un3UWezbRM6Cuxzoy3BMnHTE4tcZEOOJNjhteYLSEYZO8M7PQDFuqQF9QrxIpziCHfOuj6UF_RxGKB3TcWATwkhQUqBsItqP8hua9',
    //     'Content-Type' => 'application/json',
    // ])
    //     ->post('https://fcm.googleapis.com/fcm/send', [
    //         'to' => '/topics/'.$topic,
    //         'notification' => [
    //             'title' => $title,
    //             'body' => $body,
    //             'imageUrl'=>'https://buffer.com/cdn-cgi/image/w=1000,fit=contain,q=90,f=auto/library/content/images/size/w1200/2023/09/instagram-image-size.jpg',
    //             'mutable_content' => true,
    //             'sound' => 'Tri-tone',
    //         ],
    //         'data' => [
    //             'img'=>null,
    //         ],
    //     ]);
    // return $response->body();
    return "nothing";
}
}