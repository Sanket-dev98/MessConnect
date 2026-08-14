package com.messconnect.api.security;

import com.messconnect.api.domain.User;
import org.springframework.core.MethodParameter;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

/**
 * Resolves {@link CurrentUser}-annotated parameters from the request attribute
 * set by {@link FirebaseAuthFilter}. Because the filter runs first and 401s on
 * missing/invalid tokens, the attribute is always present here.
 */
@Component
public class CurrentUserArgumentResolver implements HandlerMethodArgumentResolver {

	@Override
	public boolean supportsParameter(MethodParameter parameter) {
		return parameter.hasParameterAnnotation(CurrentUser.class)
				&& User.class.isAssignableFrom(parameter.getParameterType());
	}

	@Override
	public Object resolveArgument(
			MethodParameter parameter,
			ModelAndViewContainer mavContainer,
			NativeWebRequest webRequest,
			WebDataBinderFactory binderFactory) {
		Object user = webRequest.getAttribute(
				FirebaseAuthFilter.AUTH_ATTR, NativeWebRequest.SCOPE_REQUEST);
		if (user == null) {
			throw new UnauthorizedException("No authenticated user on request");
		}
		return user;
	}
}
