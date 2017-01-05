package com.reactnativenavigation.layouts;

import android.support.v7.app.AppCompatActivity;
import android.widget.RelativeLayout;

import com.reactnativenavigation.params.SlidingOverlayParams;
import com.reactnativenavigation.views.slidingOverlay.SlidingOverlay;
import com.reactnativenavigation.views.slidingOverlay.SlidingOverlaysQueue;

public abstract class BaseLayout extends RelativeLayout implements Layout {

    protected SlidingOverlaysQueue slidingOverlaysQueue = new SlidingOverlaysQueue();

    public BaseLayout(AppCompatActivity activity) {
        super(activity);
    }

    @Override
    public void showSlidingOverlay(final SlidingOverlayParams params) {
        slidingOverlaysQueue.add(new SlidingOverlay(getActivity(), this, params));
    }

    protected AppCompatActivity getActivity() {
        return (AppCompatActivity) getContext();
    }
}
