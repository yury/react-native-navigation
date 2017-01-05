package com.reactnativenavigation.animation;

import android.animation.Animator;
import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.support.annotation.NonNull;
import android.view.View;
import android.view.animation.OvershootInterpolator;

import static android.view.View.TRANSLATION_Y;

public class PeekingAnimator {

    final Animator animator;

    public PeekingAnimator(View view) {
        this.animator = createAnimator(view);
    }

    public void addListener(Animator.AnimatorListener listener) {
        this.animator.addListener(listener);
    }

    public void animate() {
        animator.start();
    }

    @NonNull
    private Animator createAnimator(View view) {
        final int heightPixels = view.getLayoutParams().height;

        // TODO use VisibilityAnimator?

        view.setTranslationY(-heightPixels);

        ObjectAnimator slideIn = ObjectAnimator.ofFloat(view, TRANSLATION_Y, 0);
        slideIn.setDuration(600);
        slideIn.setInterpolator(new OvershootInterpolator(0.2f));

        ObjectAnimator slideOut = ObjectAnimator.ofFloat(view, TRANSLATION_Y, -heightPixels);
        slideIn.setDuration(300);

        AnimatorSet animatorSet = new AnimatorSet();
        animatorSet.play(slideOut).after(3000).after(slideIn);

        return animatorSet;
    }
}
