<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Admin;
use App\Models\Bill;
use App\Models\Orderitem;
use App\Models\Roll;
use App\Models\Stores;
use App\Traits\CheckAuthForAdmin;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\DB;
class AdminController extends Controller
{
    use CheckAuthForAdmin;
    public function addUser(Request $request)
    {
        $result = $this->registerOrNot($request);
        $validator = Validator::make($request->all(), [
            'userphone' => 'required|string',
            'userpassword' => 'required|string',
            'username' => 'required|string',
            'userroll' => 'required|integer|exists:rolls,id',
            'usercountry' => 'required|integer',
        ]);
        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 400);
        }
        if ($result['status'] == true && $result['rolls_name'] == 'admin') {
            //add admin but the roll is delivery
            $phone_check=Admin::where('phone',$request->userphone)->first();
            if(!$phone_check)
            {
                if ($request->userroll != 1) {
                    $res = Admin::create([
                        'phone' => $request->userphone,
                        'name' => $request->username,
                        'rolls_id' => $request->userroll,
                        'password' => $request->userpassword,
                        'country' => $request->usercountry,
                    ]);
                    if ($res == true) {
                        return response()->json(['message' => 'user has created successfully', 'error' => 0], 201);
                    } else {
                        return response()->json(['message' => 'تأكد من أن رقم الهاتف صحيح وغير مكرر'], 400);
                    }
                } else {
                    return response()->json(['message' => 'لا يمكن منح هذه الصلاحية', 'error' => 5554], 200);
                }
            }else {
                return response()->json(['message' => 'رقم الهاتف مكرر'], 400);
            }

            
        } elseif ($result['status'] == true && $result['rolls_id'] < $request->userroll && $result['country'] == $request->usercountry) {
            $phone_check=Admin::where('phone',$request->userphone)->first();
            if(!$phone_check)
            {
                $res = Admin::create([
                    'phone' => $request->userphone,
                    'name' => $request->username,
                    'rolls_id' => $request->userroll,
                    'password' => $request->userpassword,
                    'country' => $request->usercountry,
                ]);
                if ($res == true) {
                    return response()->json(['message' => 'user has created successfully', 'error' => 0], 201);
                } else {
                    return response()->json(['message' => 'تأكد من أن رقم الهاتف صحيح وغير مكرر'], 400);
                }
            }
            else {
                return response()->json(['message' => 'رقم الهاتف مكرر'], 400);
            }

        } else {
            return response()->json(['message' => 'ليست لديك صلاحية', 'error' => 5553], 400);
        }
    }
    public function registerUser(Request $request)
    {
        $result = $this->registerOrNot($request);
        $validator = Validator::make($request->all(), [
            'country' => 'nullable|string',
            'token'=> 'nullable|string'
        ]);
        if ($validator->fails()) {
            return response()->json(['message' => $validator->errors()], 400);
        }
        $admin=Admin::findOrFail($result['admin_id']);
        if($result['status'] == true && $result['rolls_name'] == 'admin')
        {
            if($admin)
            {
                $admin->country=$request->country;
                $admin->token=$request->token;
                $admin->save();
            }
            return response()->json(['country' => $result['country'], 'position' => $result['rolls_name'],'token'=>$admin->token], 200);
        }
        elseif ($result['status'] == true) {
            if($admin)
            {
                $admin->token=$request->token;
                $admin->save();
            }
                //add admin but the roll is delivery
            return response()->json(['country' => $result['country'], 'position' => $result['rolls_name'],
            'token'=>$admin->token], 200);
        } else {
            return response()->json(['message' => 'ليست لديك صلاحية', 'error' => 5553], 400);
        }
    }
    //قراءة بيانات المستخدمين الأقل منه رتبة في نفس الدولة
    public function readUsers(Request $request)
    {
        $result = $this->registerOrNot($request);
        if ($result['status'] == true) {
            //اذا كان المدير العام للموقع يمكن ارجاع كافة المستخدمين في جميع الدول
            if ($result['rolls_id'] == 1) {
                $users = Admin::where('rolls_id', '>', $result['rolls_id'])->get();
                return response()->json(['data' => $users, 'error' => 0], 200);
            } elseif($result['rolls_id'] == 2) {
                $users = Admin::where('rolls_id', '>=', $result['rolls_id'])
                    ->where('country', '=', $result['country'])
                    ->get();
                return response()->json(['data' => $users, 'error' => 0], 200);
            }
            else{
                return response()->json(['message'=>"ليس لديك صلاحية"],405);
            }
        } else {
            return response()->json(['message'=>"ليس لديك صلاحية"],405);
        }
    }

    public function updateUser(Request $request)
    {
        $result = $this->registerOrNot($request);
        if ($result['status'] == true) {
            $validator = Validator::make($request->all(), [
                'userid' => 'required|integer|exists:admins,id',
                'userphone' => 'required|string',
                'userpassword' => 'required|string',
                'username' => 'required|string',
                'userroll' => 'required|integer|exists:rolls,id',
            ]);
            if ($validator->fails()) {
                return response()->json($validator->errors(), 400);
            }
            //اذا كان المدير العام للموقع يمكن ارجاع كافة المستخدمين في جميع الدول
            if ($result['rolls_id'] == 1) {
                $validator = Validator::make($request->all(), [
                    'usercountry' => 'required|integer',
                ]);
                if ($validator->fails()) {
                    return response()->json(['message'=>$validator->errors()], 400);
                }
                $user_updatable = Admin::findOrFail($request->userid);
                $user_updatable->name = $request->username;
                $user_updatable->phone = $request->userphone;
                $user_updatable->password = $request->userpassword;
                $user_updatable->rolls_id = $request->userroll;
                $user_updatable->country = $request->usercountry;
                $res = $user_updatable->save();
                if ($res == true) {
                    return response()->json(['message' => 'تم التعديل بنجاح', 'error' => 0], 201);
                } else {
                    return response()->json(['message' => 'لم يتم التعديل', 'error' => 5553], 400);
                }
            } else {
                $user_updatable = Admin::findOrFail($request->userid);

                if ($result['rolls_id'] < $user_updatable->rolls_id && $result['rolls_id'] < $request->userroll && $result['country'] == $user_updatable->country) {
                    $user_updatable->name = $request->username;
                    $user_updatable->phone = $request->userphone;
                    $user_updatable->password = $request->userpassword;
                    $user_updatable->rolls_id = $request->userroll;
                    $res = $user_updatable->save();
                    if ($res == true) {
                        return response()->json(['message' => 'تم التعديل بنجاح', 'error' => 0], 201);
                    } else {
                        return response()->json(['message' => 'لم يتم التعديل', 'error' => 5553], 400);
                    }
                } else {
                    return response()->json(['message' => 'ليس لديك الصلاحية', 'error' => 5553], 400);
                }
            }
        } else {
            return response()->json($result);
        }
    }
    public function deleteUser(Request $request)
    {
        $result = $this->registerOrNot($request);
        if ($result['status'] == true) {
            $validator = Validator::make($request->all(), [
                'userid' => 'required|integer|exists:admins,id',
            ]);
            if ($validator->fails()) {
                return response()->json($validator->errors(), 400);
            }
            //اذا كان المدير العام للموقع يمكن ارجاع كافة المستخدمين في جميع الدول
            if ($result['rolls_id'] == 1) {
                $user_updatable = Admin::findOrFail($request->userid);
                $res = $user_updatable->delete();
                if ($res == true) {
                    return response()->json(['message' => 'تم الحذف بنجاح', 'error' => 0], 201);
                } else {
                    return response()->json(['message' => 'لم يتم الحذف', 'error' => 5553], 400);
                }
            } else {
                $user_removable = Admin::findOrFail($request->userid);

                if ($result['rolls_id'] < $user_removable->rolls_id && $result['country'] == $user_removable->country) {
                    $res = $user_removable->delete();
                    if ($res == true) {
                        return response()->json(['message' => 'تم الحذف بنجاح', 'error' => 0], 201);
                    } else {
                        return response()->json(['message' => 'لم يتم الحذف', 'error' => 5553], 400);
                    }
                } else {
                    return response()->json(['message' => 'ليس لديك الصلاحية', 'error' => 5553], 400);
                }
            }
        } else {
            return response()->json($result);
        }
    }
    public function getAllBills(Request $request)
    {
        $result = $this->registerOrNot($request);
        if ($result['status'] == true) {
            $validator = Validator::make($request->all(), [
                'status' => 'required|integer',
                'country' => 'required|integer',
            ]);
            if ($validator->fails()) {
                //error 400 bad request

                return ['status' => false, 'code' => 400, 'message' => $validator->errors(), 'error' => 5555];
            }

            //         //for pigante use
            //         $bills = DB::table('bill')
            // ->select('bill.id AS bill_id', 'bill.created_at', 'stores.*')
            // ->join('stores', 'stores.id', '=', 'bill.stores_id')
            // ->where('bill.status', 0)
            // ->where('stores.country', $request->country)
            // ->paginate($perPage);

            // if ($result['rolls_name'] == 'delivery') {
            //     $bills = DB::select('SELECT bill.id AS bill_id,bill.created_at, stores.name,stores.phone,stores.location,stores.note FROM bill, stores WHERE stores.id = bill.stores_id AND bill.status=' . $request->status . ' AND stores.country=' . $request->country);
            // } else {
            // $bills = DB::select('SELECT bill.id AS bill_id,bill.created_at, stores.* FROM bill, stores WHERE stores.id = bill.stores_id AND bill.status=' . $request->status . ' AND stores.country=' . $request->country);

            ///////////////////////////

            $query = DB::table('bill')
                ->select('bill.id AS bill_id', 'bill.created_at', 'stores.name', 'stores.phone', 'stores.location', 'stores.note')
                ->join('stores', 'stores.id', '=', 'bill.stores_id')
                ->where('bill.status', $request->status)
                ->where('stores.country', $request->country)
                ->orderByDesc('created_at')
                ->paginate(5);

            //condition with date

            // $query = DB::table('bill')
            // ->select('bill.id AS bill_id', 'bill.created_at', 'stores.name','stores.phone','stores.location','stores.note')
            // ->join('stores', 'stores.id', '=', 'bill.stores_id')
            // ->where('bill.status', $request->status)
            // ->where('bill.created_at', '<=', "2024-01-24")
            // ->where('stores.country', $request->country)->paginate(5);

            $lastPage = $query->lastPage();
            $currentPage = $query->currentPage();
            $data = $query->items();

            foreach ($data as $bill) {
                // Add the new field to each element
                $bill->orderitems = DB::select('SELECT `name`,`price`,`quantity` FROM orderitems where orderitems.bill_id=' . $bill->bill_id);
            }

            return response()->json(['data' => $data, 'last_page' => $lastPage, 'current_page' => $currentPage], 200);
        } else {
            return response()->json(['message' => 'ليس لديك صلاحية', 'error' => 5555], 401);
        }
        return response()->json(['message' => 'ليس لديك صلاحية', 'error' => 5555], 401);
    }

    //update bills
    public function updateBills(Request $request)
    {
        $result = $this->registerOrNot($request);
        if ($result['status'] == true) {
            $validator = Validator::make($request->all(), [
                'bill_id' => 'required|integer',
                'country' => 'required|integer',
                'status' => 'required|integer',
            ]);
            if ($validator->fails()) {
                //error 400 bad request

                return ['status' => false, 'code' => 400, 'message' => $validator->errors(), 'error' => 5555];
            }
            //نمنع الموصل من تحويل الفواتير الى الحالة 2
            if ($result['rolls_name'] === 'delivery' && $request->status == 1) {
                return response()->json(['message' => 'ليس لديك صلاحية للتعديل ', 'error' => 5555], 401);
            }
            if ($result['rolls_name'] == 'admin' || $result['country'] == $request->country) {
                $bill = Bill::findOrFail($request->bill_id);
                $bill->status = $request->status;
                $bill->save();
                if($request->status==1)
                {
                    //هنا نقوم بارسال اشعار الى موصلي الطلبات بالدولة
                    $this->deliveyInCountryTopic("طلب قيد التوصيل",'عزيزي الموظف لديكم طلبات قيد التوصيل قم بالدخول الى التطبيق والتحقق من الأمر',$result['country']);
                }
                return response()->json(['message' => 'تمت العملية بنجاح', 'error' => 0], 201);
            } else {
                return response()->json(['message' => 'ليس لديك صلاحية للتعديل في خارج دولتك', 'error' => 5555], 401);
            }
        } else {
            return response()->json(['message' => 'ليس لديك صلاحية', 'error' => 5555], 401);
        }
    }

    //delete bills
    public function destroyBills(Request $request)
    {
        $result = $this->registerOrNot($request);
        if ($result['status'] == true && ($result['rolls_name'] == 'admin' || $result['rolls_name'] == 'country_manager' || $result['rolls_name'] == 'delivery')) {
            $validator = Validator::make($request->all(), [
                'bill_id' => 'required|integer',
                'country' => 'required|integer',
            ]);
            if ($validator->fails()) {
                //error 400 bad request

                return ['status' => false, 'code' => 400, 'message' => $validator->errors(), 'error' => 5555];
            }
            $bill = Bill::findOrFail($request->bill_id);
            // $bill->status = $request->status;
            if ($result['rolls_name'] == 'delivery' && $bill->status == 0) {
                return response()->json(['message' => 'ليس لديك صلاحية لحذف الطلبات في هذه المرحلة', 'error' => 5555], 401);
            } else {
                $bill->delete();

                return response()->json(['message' => 'تمت العملية بنجاح', 'error' => 0], 201);
            }
        } else {
            return response()->json(['message' => 'ليس لديك صلاحية', 'error' => 5555], 401);
        }
    }
    public function getStores(Request $request)
    {
        $result = $this->registerOrNot($request);
        if ($result['status'] == true) {
            // return response()->json(['data' =>Stores::where('country',0)->get() ], 200);
            $validator = Validator::make($request->all(), [
                'store_id' => 'nullable|integer',
                'country' => 'required|integer',
            ]);
            if ($validator->fails()) {
                //error 400 bad request

                return ['status' => false, 'code' => 400, 'message' => $validator->errors(), 'error' => 5555];
            }
            //
            if ($result['rolls_name'] == 'admin' || ($result['country'] == $request->country && $result['rolls_name'] == 'country_manager')) {
                //في حالة اذا كان المستخدم يريد ارجاع مستخدم واحد فقط حسب معرف المستخدم
                if (!empty($request->store_id)) {
                    $store = Stores::findOrFail($request->store_id);
                    if (!empty($store)) {
                        if ($store->country == $request->country) {
                            return response()->json(['data' => $store]);
                        } else {
                            return response()->json(['message' => 'ان المستخدم ليس في نطاق دولتك', 'error' => 5555], 401);
                        }
                    }

                    return response()->json(['message' => 'هناك خطأ،تأكد من أن المستخدم موجود', 'error' => 5555], 401);
                }
                $stores = Stores::where('country', $request->country)->get();
                return response()->json(['data' => $stores, 'error' => 0], 200);
            } else {
                if (!empty($request->store_id)) {
                    $store = Stores::findOrFail($request->store_id, ['id', 'phone', 'location', 'note']);
                    if (!empty($store)) {
                        if ($store->country == $request->country) {
                            return response()->json(['data' => $store]);
                        } else {
                            return response()->json(['message' => 'ان المستخدم ليس في نطاق دولتك', 'error' => 5555], 401);
                        }
                    }

                    return response()->json(['message' => 'هناك خطأ،تأكد من أن المستخدم موجود', 'error' => 5555], 401);
                }
                $stores = Stores::where('country', $request->country)
                    ->select('id', 'name', 'phone', 'location', 'note')
                    ->get();
                return response()->json(['data' => $stores, 'error' => 0], 200);
            }
        } else {
            return response()->json(['message' => 'ليس لديك صلاحية', 'error' => 5555], 401);
        }
    }
    //update specific store
    public function deleteStore(Request $request)
    {
        $result = $this->registerOrNot($request);
        if ($result['status'] == true && $result['rolls_name'] == 'admin') {
            $validator = Validator::make($request->all(), [
                'store_id' => 'required|integer',
            ]);
            if ($validator->fails()) {
                return response()->json(['message'=>$validator->errors()], 400);
            }
            $stores = Stores::findOrFail($request->store_id);
            if (!$stores) {
                return response()->json(['message'=>'المستخدم غير موجود'], 404);
            }
            $stores->delete();

            return response()->json(['message' => 'تم حذف البيانات بنجاح'], 201);
        } else {
            return response()->json(['message' => 'ليس لديك صلاحية', 'error' => 5555], 401);
        }
    }
    //update specific store
    public function updateStore(Request $request)
    {
        $result = $this->registerOrNot($request);
        if ($result['status'] == true) {
            $validator = Validator::make($request->all(), [
                'store_id' => 'required|integer',
                'store_name' => 'required|string',
                'store_phone' => 'required|string',
                'store_password' => 'required|string',
                'store_location' => 'nullable|string',
                'store_note' => 'nullable|string',
                'store_country' => 'nullable|integer',
            ]);
            if ($validator->fails()) {
                return response()->json(['message' => $validator->errors()], 400);
            }

            $stores = Stores::find($request->store_id);
            if (!$stores) {
                return response()->json(['message' => 'store not found'], 404);
            }

            if ($result['rolls_name'] == 'admin' || $result['country'] == $request->store_country) {
                $stores->name = $request->input('store_name');

                //اذا كان المستخدم عبارة عن موصل فلا يمكن تعديل كلمة السر ولا رقم الهاتف
                if ($result['rolls_name'] !== 'delivery') {
                    $stores->password = $request->input('store_password');
                    $stores->phone = $request->input('store_phone');
                    $stores->country = $request->input('store_country');
                }
                $stores->location = $request->input('store_location');
                $stores->note = $request->input('store_note');

                $stores->save();

                return response()->json(['message' => 'تم تعديل البيانات بنجاح'], 201);
            } else {
                return response()->json(['message' => 'ليس لديك صلاحية لتعديل ببانات المستخدم', 'error' => 5555], 401);
            }
        } else {
            return response()->json(['message' => 'ليس لديك صلاحية', 'error' => 5555], 401);
        }
    }
    //اجمالي المبيعات حسب المدة الزمنية
    public function getPayments(Request $request)
    {
        $result = $this->registerOrNot($request);
        if ($result['status'] == true && ($result['rolls_name']=='admin' || $result['rolls_name']=='country_manager')) {
            $validator = Validator::make($request->all(), [
                'firstDate' => 'required|string',
                'lastDate' => 'required|string',
                'country' => 'required|integer',
            ]);
            if ($validator->fails()) {
                //error 400 bad request

                return ['status' => false, 'code' => 400, 'message' => $validator->errors(), 'error' => 5555];
            }

            // $query = DB::table('bill')
            // ->select('bill.id AS bill_id', 'bill.created_at', 'stores.name','stores.phone','stores.location','stores.note')
            // ->join('stores', 'stores.id', '=', 'bill.stores_id')
            // ->where('bill.status', $request->status)
            // ->where('bill.created_at', '<=', "2024-01-24")
            // ->where('stores.country', $request->country)->paginate(5);

            //2 means all bills have payed
            $query = DB::table('bill')
                ->select('bill.id AS bill_id')
                ->where('bill.status', '2')
                ->whereBetween('bill.created_at', [$request->firstDate,$request->lastDate])
                ->where('bill.country', $request->country)
                ->get();
            $inList=[];
            //هذه تسرع الاستعلام على قاعدة البيانات
            foreach($query as $bill)
            {
                $inList[]=$bill->bill_id;
            }
            $total_price = DB::table('orderitems')
            ->selectRaw('SUM(quantity * price) as total')
            ->whereIn('orderitems.bill_id', $inList)
            ->value('total');
            // foreach ($query as $bill) {
            //     $sum = DB::table('orderitems')
            //         ->selectRaw('SUM(quantity * price) as total')
            //         ->whereIn('orderitems.bill_id', $bill->bill_id)
            //         ->value('total');
            //     $total_price += $sum;
            // }

            return response()->json(['total_price' => $total_price], 200);
        } else {
            return response()->json(['message' => 'ليس لديك صلاحية', 'error' => 5555], 401);
        }
        return response()->json(['message' => 'ليس لديك صلاحية', 'error' => 5555], 401);
    }
    public function getMainInfo(Request $request)
    {
        //جلب المعلومات المتعلقة بالطلبات الجديدة
        //والطلبات قيد التوصيل
        $result = $this->registerOrNot($request);
        if($result['status'] == true)
        {
            $validator = Validator::make($request->all(), [
                'country' => 'required|integer'
            ]);
            if ($validator->fails()) {
                //error 400 bad request
                return ['status' => false, 'code' => 400, 'message' => $validator->errors(), 'error' => 5555];
            }
            $counter0 = DB::table('bill')
            ->selectRaw('COUNT(*) as counter')
                    ->where('status','0')
                    ->where('country', $request->country)
                    ->value('counter');
            $counter1 = DB::table('bill')
                    ->selectRaw('COUNT(*) as counter')
                            ->where('status','1')
                            ->where('country', $request->country)
                            ->value('counter');
            
                    return response()->json(['counter0' => $counter0,'counter1'=>$counter1], 200);
        }
        else {
            return response()->json(['message' => 'ليس لديك صلاحية', 'error' => 5555], 401);
        }
        return response()->json(['message' => 'ليس لديك صلاحية', 'error' => 5555], 401);
        
        

    }
}
