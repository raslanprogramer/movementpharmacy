<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Advertisement;
use Illuminate\Http\Request;
use App\Traits\CheckAuthForAdmin;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\File;

class AdvertisementController extends Controller
{
    use CheckAuthForAdmin;
    public function index($country)
    {
        if(is_numeric($country))
        {
            return response()->json(['data'=>Advertisement::where('country',$country)->get()],200);
        }
        return response()->json(['data'=>Advertisement::where('country',0)->get()],200);
    }
    public function addAdvs(Request $request)
    {
        $result=$this->registerOrNot($request);
        if($result["status"]==true && ($result["rolls_name"]=="admin" || $result["rolls_name"]=="country_manager"))
        {
            $validator = Validator::make($request->all(), [
                'img' => 'required|image|mimes:jpeg,png,jpg,gif|max:2048',
                'country' => 'nullable|integer',
            ]);
            if ($validator->fails()) {
                return response()->json(['message'=>$validator->errors()], 400);
            }
            $advs=new Advertisement();
            if($result["rolls_name"]=="country_manager")
            {
            $advs->country=$result["country"];
            }
            else
            {
                $advs->country=$request->country;
            }
            $image = $request->file('img');
                    $imageName = time() . '_' . $image->getClientOriginalName();
                    $image->move(public_path('images'), $imageName);
                    $advs->img = $imageName;
            
            // Save the advertisement
            $advs->save();
            $this->sendnotifcation_toTopic('عرض جديد','عزيزي العميل تصفح الاعلانات في التطبيق لمعرفة التفاصيل',$advs->img,$advs->country);
            return response()->json(['data'=>$advs],201);
        }
        return response()->json(['message'=>"ليس لديك صلاحية","error"=>5555],401);
    }
    public function updateAdvs(Request $request)
    {
        $result=$this->registerOrNot($request);
        if($result["status"]==true && ($result["rolls_name"]=="admin" || $result["rolls_name"]=="country_manager"))
        {
            $validator = Validator::make($request->all(), [
                'img' => 'nullable|image|mimes:jpeg,png,jpg,gif|max:2048',
                'advs_id'=>'required|integer',
                'country' => 'nullable|integer',
            ]);
            if ($validator->fails()) {
                return response()->json($validator->errors(), 400);
            }
            $advs=Advertisement::findOrFail($request->advs_id);
            if($result["rolls_name"]=="country_manager")
            {
            $advs->country=$result["country"];
            }
            else
            {
                $advs->country=$request->country;
            }



            if ($advs->img && $request->hasFile('img')) {
                $existingImagePath = public_path('images') . '/' . $advs->img;
                if (File::exists($existingImagePath)) {
                    // Remove the existing image from the public directory
                    File::delete($existingImagePath);
                }

                //add image
                $image = $request->file('img');
                $imageName = time() . '_' . $image->getClientOriginalName();
                $image->move(public_path('images'), $imageName);
                $advs->img = $imageName;
            }
            // Save updateing
            $advs->save();
            return response()->json(['message'=>"تم تعديل الاعلان بنجاح","error"=>5555],201);
        }
        return response()->json(['message'=>"ليس لديك صلاحية","error"=>5555],401);
    }
    //delete advertisement
    public function destroy(Request $request)
    {
        $result=$this->registerOrNot($request);
        if($result["status"]==true && ($result["rolls_name"]=="admin" || $result["rolls_name"]=="country_manager"))
        {
            $validator = Validator::make($request->all(), [
                'advs_id' => 'required|integer',
            ]);
            if ($validator->fails()) {
                return response()->json(['message'=>$validator->errors()], 400);
            }
            $advs=Advertisement::findOrFail($request->advs_id);
            if(empty($advs))
            {
                return response()->json(['message'=>"هناك خطأ","error"=>5555],401);
            }
            if($result["rolls_name"]=="country_manager")
            {
                if(!$result["country"]==$advs->country)
                {
                    return response()->json(['message'=>"ليس لديك صلاحية بتعديل اعلان خارج دولتك","error"=>5555],401);
                }
            }

            if ($advs->img) {
                $existingImagePath = public_path('images') . '/' . $advs->img;
                if (File::exists($existingImagePath)) {
                    // Remove the existing image from the public directory
                    File::delete($existingImagePath);
                }
            }
            $advs->delete();
    
            // Optionally, you can redirect to a different page
            return response()->json(['message'=>"تم حذف الاعلان بنجاح",'error'=>0],201);
        }
        return response()->json(['message'=>"ليس لديك صلاحية","error"=>5555],401);
    }
}
