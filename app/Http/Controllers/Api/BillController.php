<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Admin;
use Illuminate\Http\Request;
use App\Models\Bill;
use App\Models\Cart;
use App\Models\Orderitem;
use App\Models\Product;
use App\Models\Stores;
use Carbon\Carbon;
use Illuminate\Support\Facades\Validator;
use App\Traits\CheckAuthForAdmin;
use Illuminate\Support\Facades\DB;

class BillController extends Controller
{
    use CheckAuthForAdmin;

    public function index(Request $request)
    {
        // $store_password,$store_phone,$status

        // $bills= Bill::where('stores_id',$store_id)->get();
        // return $bills;
        
        $validator = Validator::make($request->all(),
            [
                'status'=>'required|integer'
            ]
        );
        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }
        $result=$this->authStore($request);
        if($result["status"]==true)
        {
            $status=$request->status;//هذا الشرط من أجل نجلب الفواتير ذو الرقم 2 والتي تم الموفقة عليها
            $statuses=[];
            if($status==1)
            {
                $status=2;
            $statuses=[2];
            }
            elseif($status==0)
            {
            $statuses=[0,1];
            }
            //يجب تعديل عدد العناصر التي تجلب في كل مرة 10
            $orders= Stores::where('phone',$request->phone)->first()->bills()->whereIn('status',$statuses)->orderByDesc('created_at')->with('orderitems')->paginate(10);
            return response()->json(['data'=>$orders],200);
        }
        else{
            return response()->json($result,401);
        }
        // return Stores::with('bills')->get();
    }
    public function store(Request $request)
{
    
    // Retrieve the necessary data from the request
    $products = $request->input('products');


        $result=$this->authStore($request);
        if($result["status"]==true)
        {
            
    // Create a new bill
    $bill = new Bill();
    $bill->stores_id = $result["store_id"];
    $bill->country=$result["store_country"];
    $bill->created_at=Carbon::now();
    $bill->save();

    //  // Create a new product
    //  $bill = new Bill();
    //  $bill->store_id = $storeId;
    //  $bill->save();

    // Save the products in the bill
    foreach ($products as $product) {
        $product_temp=Product::find($product['id']);
        Orderitem::create([
        'bill_id'=>$bill->id,
        'name'=>$product_temp->name,
        'price'=>$product_temp->price,
        'quantity'=>$product['quantity']
        ]);
    }
    $cart = Cart::where('stores_id', $result['store_id'])->first();
if ($cart) {
    DB::table('carts_products')->where('carts_id', $cart->id)->delete();
}

    // Additional logic for the purchase process

    // Return a response
    //هنا قمنا بارسال اشعار الى المسؤول بالدولة
    $admin = Admin::where('country', $result["store_country"])
    ->where('rolls_id', '2')
    ->first();
    $this->sendnotifcation($admin->token,"طلب جديد",'لديك طلب جديد  الر جاء دخول التطبيق للرد على الطلب او رفضه');


    return response()->json(['message' => 'Bill saved successfully'],201);
        }
}
public function update($bill_id)
{
    $validator = Validator::make(
        [
            'id' => $bill_id,
            'status'=>request('status')
        ],
        [
            'id' => 'required|integer',
            'status'=>'required|integer'
        ]
    );
    if ($validator->fails()) {
        return response()->json($validator->errors(), 400);
    }
    $bill = Bill::find($bill_id);
    if (!$bill) {
        return response()->json(['error'=>0,'message'=>'bill not found'], 404);
    }
    $bill->status=request('status');
    $bill->save();
    return response()->json(['error'=>0,'message'=>'bill updated successfully']);
}
public function destroy($bill_id)
{
    $validator = Validator::make(
        [
            'id' => $bill_id,
        ],
        [
            'id' => 'required|integer',
        ]
    );
    if ($validator->fails()) {
        return response()->json($validator->errors(), 400);
    }
    $bill = Bill::find($bill_id);
    if (!$bill) {
        return response()->json(['error'=>0,'message'=>'bill not found'], 404);
    }
    Orderitem::where('bill_id',$bill_id)->delete();
    $bill->delete();
    return response()->json(['error'=>0,'message'=>'bill deleted successfully']);
}
}