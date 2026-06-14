import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:news/api/api_manager.dart';
import 'package:news/models/source_response.dart';
import 'package:news/screens/filter/models/category_model.dart';
import 'package:news/widgets/error_widget.dart';
import 'package:news/widgets/loading_widget.dart';
import 'package:news/widgets/source_tab_bar.dart';
class SourceFutureWidget extends StatefulWidget {
 final CategoryModel category;
 final String query;
  const SourceFutureWidget({super.key,required this.category,required this.query});

  @override
  State<SourceFutureWidget> createState() => _SourceFutureWidgetState();
}

class _SourceFutureWidgetState extends State<SourceFutureWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SourceResponse>(future: ApiManager.getSources(widget.category.id)
        , builder: (context, snapshot) {
          if(snapshot.connectionState==ConnectionState.waiting){
            return LoadingWidget();
          }else if(snapshot.hasError){
        return ErrorPopUpWidget(message: 'something_went_wrong'.tr(), onPressed:(){
          ApiManager.getSources(widget.category.id);
          setState(() {
          });
        });
          }
          if(snapshot.data?.status!='ok'){
            return ErrorPopUpWidget(message:snapshot.data?.message??'something_went_wrong'.tr(),
                onPressed:(){
                  ApiManager.getSources(widget.category.id);
                  setState(() {
                  });
                }
            );
          }
         return SourceTabBar(sources: snapshot.data!,query: widget.query,);
        },);
  }
}
