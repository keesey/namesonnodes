package org.namesonnodes.validators.xml;

import static java.lang.annotation.ElementType.FIELD;
import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.RetentionPolicy.RUNTIME;
import java.lang.annotation.Documented;
import java.lang.annotation.Retention;
import java.lang.annotation.Target;
import org.hibernate.validator.ValidatorClass;

@Documented
@ValidatorClass(XMLValidator.class)
@Target( { METHOD, FIELD })
@Retention(RUNTIME)
public @interface XML
{
	String message() default "{validator.xml}";
	String rootNodeName() default "";
	String targetNamespace();
}
