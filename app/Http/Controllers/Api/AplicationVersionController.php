<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\ApplicationVersion;
use Illuminate\Http\Request;
use App\Traits\CheckAuthForAdmin;
use Illuminate\Support\Facades\Validator;

class AplicationVersionController extends Controller
{
    use CheckAuthForAdmin;
    
    public function index(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'version'=>'required|string',
        ]);
        if ($validator->fails()) {
            //error 400 bad request
            return response()->json($validator->errors(),400);
        }
        $result=$this->authStore($request);
        if ($result["status"] == true) {
            $app_version = ApplicationVersion::orderByDesc('id')->first();
            if ($app_version->version == $request->version) {
                return response()->json(['message' => "ok"],200);
            } else if($app_version->required=="required"){
                return response()->json(['message' => "no",'required'=>'yes','url'=>url('/download-apk')],200);
            }else{
                return response()->json(['message' => "no",'required'=>'no','url'=>url('/download-apk')],200);
            }
        }
        return response()->json([],404);
    }
}
