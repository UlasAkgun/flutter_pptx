import 'package:json_annotation/json_annotation.dart';
import 'package:mustache_template/mustache_template.dart';

part 'textual_slide.xml.g.dart';

const _source = r'''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sld xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <p:cSld>
    <p:spTree>
      <p:nvGrpSpPr>
        <p:cNvPr id="1" name=""/>
        <p:cNvGrpSpPr/>
        <p:nvPr/>
      </p:nvGrpSpPr>
      <p:grpSpPr>
        <a:xfrm>
          <a:off x="0" y="0"/>
          <a:ext cx="0" cy="0"/>
          <a:chOff x="0" y="0"/>
          <a:chExt cx="0" cy="0"/>
        </a:xfrm>
      </p:grpSpPr>
      <p:sp>
        <p:nvSpPr>
          <p:cNvPr id="2" name="Title 1"/>
          <p:cNvSpPr>
            <a:spLocks noGrp="1"/>
          </p:cNvSpPr>
          <p:nvPr>
            <p:ph type="title"/>
          </p:nvPr>
        </p:nvSpPr>
        <p:spPr/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          <a:p>
            <a:r>
              <a:rPr dirty="0" lang="en-US" smtClean="0"/>
              <a:t>{{title}}</a:t>
            </a:r>
            <a:endParaRPr dirty="0" lang="en-US"/>
          </a:p>
        </p:txBody>
      </p:sp>
      <p:sp>
        <p:nvSpPr>
          <p:cNvPr id="3" name="Content Placeholder 2"/>
          <p:cNvSpPr>
            <a:spLocks noGrp="1"/>
          </p:cNvSpPr>
          <p:nvPr>
            <p:ph idx="1"/>
          </p:nvPr>
        </p:nvSpPr>
        <p:spPr/>
        <p:txBody>
          <a:bodyPr/>
          <a:lstStyle/>
          {{#content}}
          <a:p>
            <a:r>
              <a:rPr dirty="0" lang="en-US" smtClean="0"/>
              <a:t>{{value}}</a:t>
            </a:r>
            {{#last}}
            <a:endParaRPr lang="en-US"/>
            {{/last}}
          </a:p>
          {{/content}}
        </p:txBody>
      </p:sp>
    </p:spTree>
    <p:extLst>
      <p:ext uri="{BB962C8B-B14F-4D97-AF65-F5344CB8AC3E}">
        <p14:creationId val="1231192379" xmlns:p14="http://schemas.microsoft.com/office/powerpoint/2010/main"/>
      </p:ext>
    </p:extLst>
  </p:cSld>
  <p:clrMapOvr>
    <a:masterClrMapping/>
  </p:clrMapOvr>
</p:sld>
''';

@JsonSerializable(createFactory: false)
class Content {
  final String value;
  final bool last;

  Content({
    required this.value,
    required this.last,
  });

  Map<String, dynamic> toJson() => _$ContentToJson(this);
}

@JsonSerializable(createFactory: false)
class Source {
  final String title;
  final List<Content> content;

  Source({
    required this.title,
    required this.content,
  });

  factory Source.content({
    required String title,
    required List<String> content,
  }) {
    return Source(
      title: title,
      content: content
          .map((e) => Content(value: e, last: e == content.last))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => _$SourceToJson(this);
}

final _template = Template(
  _source.trim(),
  name: 'textual_slide.xml',
  htmlEscapeValues: false,
);

String renderString(Source data) {
  return _template.renderString(data.toJson());
}
