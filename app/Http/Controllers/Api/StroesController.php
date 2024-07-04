<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Admin;
use App\Models\Stores;
use App\Models\Cart;
use Hamcrest\Core\IsNull;
use Illuminate\Http\Request;
use Illuminate\Session\Store;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\File;

use function PHPUnit\Framework\isEmpty;
use function PHPUnit\Framework\isNan;
use function PHPUnit\Framework\isNull;
use App\Traits\CheckAuthForAdmin;

class StroesController extends Controller
{
    use CheckAuthForAdmin;

    public function index(Request $request)
    {
        $result = $this->authStore($request);
        if ($result["status"] == true) {
            $stores = Stores::findOrFail($result['store_id']);
            if (!$stores) {
                return response()->json('store not found', 404);
            }
            return response()->json(["country" => $stores->country, "location" => $stores->location], 200);
        }
        return response()->json(['error' => 555]);
    }
    public function hasAcount(Request $request)
    {
        //اذا كان المستخدم لديه حساب سابق
        $validator = Validator::make($request->all(), [
            'phone' => 'required|string',
            'password' => 'required|string',
            'token'=> 'nullable|string'
        ]);
        if ($validator->fails()) {
            //error 400 bad request
            return response()->json($validator->errors(), 400);
        }
        $check = Stores::where('phone', $request->phone)->first();
        if ($check == null) {
            return response()->json(['message' => "رقم الهاتف ليس مسجلا"], 405);
        } else if ($check->password !== $request->password) {
            return response()->json(['message' => "كلمة السر غير صحيحة،اذا نسيت كلمة السر الرجاء الاتصال بخدمة العملاء"], 405);
        } else {
            $check->token=$request->token;
            $check->save();
            return response()->json(['data' => $check], 200);
        }
        return response()->json(['message' => "هناك خطأ", 'error' => 555], 401);
    }
    public function fetch()
    {
        $stores = Stores::all();
        return response()->json(['data' => $stores]);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string',
            'phone' => 'required|string',
            'password' => 'required|string',
            'location' => 'nullable|string',
            'note' => 'nullable|string',
            'country' => 'required|integer',
            'token'=> 'nullable|string'
        ]);

        if ($validator->fails()) {
            //error 400 bad request
            return response()->json($validator->errors(), 406);
        } else {
            $check = Stores::where('phone', $request->phone)->get();
            if (!$check->isEmpty()) {
                return response()->json(['message' => 'هذا الحساب موجود بالفعل ،الرجاء الاتصال بخدمة العملاء', 'data' => $check], 305);
            }
            $stores = new Stores();
            $stores->name = $request->input('name');
            $stores->phone = $request->input('phone');
            $stores->password = $request->input('password');
            $stores->location = $request->input('location');
            $stores->note = $request->input('note');
            $stores->country = $request->input('country');
            $stores->token=$request->input('token');
            $stores->save();
            //create cart for the user automaticlly
            Cart::create([
                'stores_id' => $stores->id
            ]);
            
            $admin = Admin::where('country', $stores->country)
                ->where('rolls_id', 2)
                ->first();

            if ($admin) {
                $phone = $admin->phone;
                return response()->json(['data' => 'success', 'admin_phone' => $phone], 201);
                // Do something with the phone value
            } else {
                return response()->json(['data' => 'success', 'admin_phone' => ''], 201);
                // Admin with the specified country and roll_id not found
            }
        }
        return response()->json([], 404);
    }

    public function update(Request $request)
    {

        $validator = Validator::make(
            $request->all(),
            [
                'phone' => 'required|string',
                'password' => 'required|string',
                'location' => 'nullable|string',
                'country' => 'required|integer',
            ]
        );

        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }
        $result = $this->authStore($request);
        if ($result["status"] == true) {
            $stores = Stores::find($result['store_id']);
            if (!$stores) {
                return response()->json('store not found', 404);
            }

            $stores->location = $request->input('location');
            $stores->country = $request->input('country');
            $stores->save();

            return response()->json(['data' => 'success'], 201);
        }
        return response()->json([], 404);
    }
}
