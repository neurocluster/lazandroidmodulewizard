package org.lamw.appbatterymanagerdemo1;

import java.lang.reflect.Field;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ToggleButton;
import android.view.Gravity;

/*Draft java code by "Lazarus Android Module Wizard" [1/6/2015 22:13:32]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl template*/

public class jToggleButton extends ToggleButton /*dummy*/ { //please, fix what GUI object will be extended!

   private long       pascalObj = 0;    // Pascal Object
   private Controls   controls  = null; // Control Class for events
   private jCommons LAMWCommon;

   private Context context = null;
   private OnClickListener onClickListener;   // click event

   private OnLongClickListener onLongClickListener;  //by a6p
   private Boolean  mEnabledLongClick  = false;

   private Boolean enabled  = false;           // click-touch enabled!
   boolean mState = false;

   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

   public jToggleButton(Controls _ctrls, long _Self) { //Add more others news "_xxx"p arams if needed!
      super(_ctrls.activity);
      context   = _ctrls.activity;

      pascalObj = _Self;
      controls  = _ctrls;
	  LAMWCommon = new jCommons(this,context,pascalObj);

      onClickListener = new OnClickListener(){

         /*.*/public void onClick(View view){  //please, do not remove /*.*/ mask for parse invisibility!
            mState = !mState;
            if (enabled) {
               controls.pOnClickToggleButton(pascalObj, mState);
            }
         };
      };
      setOnClickListener(onClickListener);

      onLongClickListener = new OnLongClickListener() {
            @Override
            public boolean onLongClick(View arg0) {
               mState = !mState;
               if (enabled) {
                  if (mEnabledLongClick) {
                     controls.pOnLongClickToggleButton(pascalObj, mState);
                  }
               }
               return false;  //true if the callback consumed the long click, false otherwise.
            }
      };
      setOnLongClickListener(onLongClickListener);

   } //end constructor

   public void jFree() {
      //free local objects...      
      setOnClickListener(null);
  	  LAMWCommon.free();
   }

   public void SetViewParent(ViewGroup _viewgroup) {
	   LAMWCommon.setParent(_viewgroup);
   }

   public void RemoveFromViewParent() {
	   LAMWCommon.removeFromViewParent();
   }

   public View GetView() {
      return this;
   }

   public void SetLParamWidth(int _w) {
		LAMWCommon.setLParamWidth(_w);
   }

   public void SetLParamHeight(int _h) {
	   LAMWCommon.setLParamHeight(_h);
   }

   public void SetLGravity(int _g) {
	   LAMWCommon.setLGravity(_g);
   }

   public void setLWeight(float _w) {
	   LAMWCommon.setLWeight(_w);
   }

   public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
		LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);
   }

   public void AddLParamsAnchorRule(int _rule) {
	   LAMWCommon.addLParamsAnchorRule(_rule);
   }

   public void AddLParamsParentRule(int _rule) {
	   LAMWCommon.addLParamsParentRule(_rule);
   }

   public void SetLayoutAll(int _idAnchor) {
	   LAMWCommon.setLayoutAll(_idAnchor);
   }

   public void ClearLayoutAll() {
	   LAMWCommon.clearLayoutAll();
   }

   //write others [public] methods code here......
   //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...

   public void SetChecked(boolean _value) {
      mState = _value;
      this.setChecked(_value);
   }

   public void SetTextOn(String _caption) {
      this.setTextOn(_caption);
   }

   public void SetTextOff(String _caption) {
      this.setTextOff(_caption);
   }

   public void Toggle() { //reset toggle button value.
      mState = !mState;
      this.toggle();
   }

   public boolean IsChecked(){
      return this.IsChecked();
   }

   public void SetBackgroundDrawable(String _imageIdentifier) {
      this.setBackgroundDrawable(controls.GetDrawableResourceById(controls.GetDrawableResourceId(_imageIdentifier)));
   }

   public void DispatchOnToggleEvent(boolean _value) {
      enabled = _value;
   }

   public void SetEnabledLongClick(boolean _enableLongClick) {
      mEnabledLongClick = _enableLongClick;
   }

} //end class

