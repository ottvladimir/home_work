# Домашнее задание к занятию "7.6. Написание собственных провайдеров для Terraform."

Бывает, что 
* общедоступная документация по терраформ ресурсам не всегда достоверна,
* в документации не хватает каких-нибудь правил валидации или неточно описаны параметры,
* понадобиться использовать провайдер без официальной документации,
* может возникнуть необходимость написать свой провайдер для системы используемой в ваших проектах.   

## Задача 1. 
1. Найдите, где перечислены все доступные `resource` и `data_source`, приложите ссылку на эти строки в коде на 
гитхабе.     
 resources --> https://github.com/hashicorp/terraform-provider-aws/blob/575fc2f7813656ddfc21d8a0aefc3414e1506118/aws/provider.go#L445  
 data_sources --> https://github.com/hashicorp/terraform-provider-aws/blob/575fc2f7813656ddfc21d8a0aefc3414e1506118/aws/provider.go#L186
1. Для создания очереди сообщений SQS используется ресурс `aws_sqs_queue` у которого есть параметр `name`. 
    * С каким другим параметром конфликтует `name`?  
      https://github.com/hashicorp/terraform-provider-aws/blob/8e4d8a3f3f781b83f96217c2275f541c893fec5a/aws/resource_aws_sqs_queue.go#L56 
    * Максимальная длина имени машины   
      https://github.com/hashicorp/terraform-provider-aws/blob/27a50522f2becdbbac0a788f6f715049b343f33c/aws/validators.go#L1198 
    * Какому регулярному выражению должно подчиняться имя? `^[a-zA-Z0-9-_]+$`   
      https://github.com/hashicorp/terraform-provider-aws/blob/27a50522f2becdbbac0a788f6f715049b343f33c/aws/validators.go#L1204
## Задача 2. (Не обязательно) 
В рамках вебинара и презентации мы разобрали как создать свой собственный провайдер на примере кофемашины. 
Также вот официальная документация о создании провайдера: 
[https://learn.hashicorp.com/collections/terraform/providers](https://learn.hashicorp.com/collections/terraform/providers).

1. Проделайте все шаги создания провайдера.
2. В виде результата приложение ссылку на исходный код.
3. Попробуйте скомпилировать провайдер, если получится то приложите снимок экрана с командой и результатом компиляции.   
