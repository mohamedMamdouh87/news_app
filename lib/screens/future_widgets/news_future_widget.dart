import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:news/utils/app_size.dart';
import '../../api/api_manager.dart';
import '../../models/news_response.dart';
import '../../models/source_response.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/news_item.dart';
class NewsFutureWidget extends StatefulWidget {
  final Source source;
  final String query;
  const NewsFutureWidget({super.key,required this.source,required this.query});

  @override
  State<NewsFutureWidget> createState() => _NewsFutureWidgetState();
}

class _NewsFutureWidgetState extends State<NewsFutureWidget> {
  @override
  Widget build(BuildContext context) {
    var height=context.height;
    return FutureBuilder<NewsResponse>(future: ApiManager.getNews(widget.source.id??'',getLangText(),widget.query),
        builder: (context, snapshot) {
      List<Article> articles=snapshot.data?.articles??[];
          if(snapshot.connectionState==ConnectionState.waiting){
            return LoadingWidget();
          }else if(snapshot.hasError){
            return ErrorPopUpWidget(message: 'something_went_wrong'.tr(), onPressed:() {
              ApiManager.getNews(widget.source.id ?? '',getLangText(),widget.query);
              setState(() {});
            });
            }
          if(snapshot.data?.status!='ok'){
            return ErrorPopUpWidget(message:snapshot.data?.message??'something_went_wrong'.tr(),
                onPressed:(){
              ApiManager.getNews(widget.source.id ?? '',getLangText(),widget.query);
              setState(() {
              });
                });
          }
          return articles.isEmpty?Center(child: Text('no_news_found'.tr(),style: Theme.of(context).textTheme.labelSmall,),):
           ListView.separated(itemBuilder: (context, index) {
            return NewsItem(article:snapshot.data!.articles![index] ,);
          },
              separatorBuilder: (context, index) {
                return SizedBox(height: height*0.02,);
              },
              itemCount: snapshot.data?.articles?.length??0);
          }
        );
  }
  String getLangText(){
    return context.locale.languageCode=='en'?'en':'ar';
  }
}
