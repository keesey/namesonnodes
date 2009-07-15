package org.namesonnodes.validators.ip;

import static java.lang.annotation.ElementType.FIELD;
import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.RetentionPolicy.RUNTIME;
import java.lang.annotation.Documented;
import java.lang.annotation.Retention;
import java.lang.annotation.Target;
import org.hibernate.validator.ValidatorClass;

@Documented
@ValidatorClass(IPAddressValidator.class)
@Target( { METHOD, FIELD })
@Retention(RUNTIME)
public @interface IPAddress
{
	String message() default "{validator.ipAddress}";
}
