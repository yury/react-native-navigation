package com.reactnativenavigation.layouts;

import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.RelativeLayout;

import com.reactnativenavigation.params.SlidingOverlayParams;
import com.reactnativenavigation.utils.ViewUtils;
import com.reactnativenavigation.views.ContentView;
import com.reactnativenavigation.views.slidingOverlay.SlidingOverlay;

public abstract class BaseLayout extends RelativeLayout implements Layout {

    public BaseLayout(AppCompatActivity activity) {
        super(activity);
    }

    @Override
    public void showSlidingOverlay(final SlidingOverlayParams params) {
        new SlidingOverlay(getActivity(), this, params).show();
    }

    protected AppCompatActivity getActivity() {
        return (AppCompatActivity) getContext();
    }
}
