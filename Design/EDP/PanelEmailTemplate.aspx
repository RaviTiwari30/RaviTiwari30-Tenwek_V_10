<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PanelEmailTemplate.aspx.cs" Inherits="Design_EDP_PanelEmailTemplate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <style type="text/css">
        /*#cke_14, #cke_21, #cke_29, #cke_34, #cke_66, #cke_70, #cke_86 {
            display: none !important;
        }*/
    </style>


    <script type="text/javascript">

        $(document).ready(function () {
            $bindPanel(function () {
                getPanelTemplateDynamicField(function () { });
            });

            CKEDITOR.config.toolbar = [
	                { name: 'basicstyles', groups: ['basicstyles', 'cleanup'], items: ['Bold', 'Italic', 'Strike', '-', 'RemoveFormat'] },
	                { name: 'paragraph', groups: ['list', 'indent', 'blocks', 'align', 'bidi'], items: ['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote'] },
	                { name: 'styles', items: ['Styles', 'Format'] },
                    { name: 'others', items: ['-'] },
                    { name: 'tools', items: ['Maximize'] }
            ];
            CKEDITOR.config.toolbarGroups = [
                { name: 'basicstyles', groups: ['basicstyles', 'cleanup'] },
                { name: 'paragraph', groups: ['list', 'indent', 'blocks', 'align', 'bidi'] },
                { name: 'styles' },
                { name: 'colors' },
                { name: 'others' }, { name: 'tools' },
            ];
        });


        $bindPanel = function (callback) {
            serverCall('../Common/CommonService.asmx/bindPanel', {}, function (response) {
                var ddlPanel = $('#ddlPanel');
                //(PanelID, '#', ReferenceCodeOPD, '#', HideRate, '#', ShowPrintOut)
                ddlPanel.bindDropDown({ data: JSON.parse(response), valueField: 'PanelID', textField: 'Company_Name', isSearchAble: true, selectedValue: '<%=GetGlobalResourceObject("Resource", "DefaultPanelID") %>' });
                callback({ panelCompany: ddlPanel.val() });
            });
        }


        var getPanelTemplateDynamicField = function () {
            serverCall('PanelEmailTemplate.aspx/GetPanelTemplateDynamicField', {}, function (response) {
                var ddlField = $('#ddlField');
                ddlField.bindDropDown({ data: JSON.parse(response), defaultValue: 'Select', valueField: 'ValueField', textField: 'DisplayField', isSearchAble: true });
                callback();
            });
        }



        var addFieldName = function (selectedField) {

            if (selectedField == '0')
                return;

            var _temp = CKEDITOR.instances.txtEmailBody.getData();
            CKEDITOR.instances.txtEmailBody.setData(_temp + '&nbsp;' + selectedField + '&nbsp;');

        }


        var getPanelTemplateDetails = function (callback) {
            var mailTemplate = {};
            var _txtSubject = $('#txtSubject');
            var _txtTemplateName = $('#txtTemplateName');
            mailTemplate.panelID = Number($('#ddlPanel').val()[0]);
            mailTemplate.mailSubject = $.trim(_txtSubject.val());
            mailTemplate.templateName = $.trim(_txtTemplateName.val());
            mailTemplate.template = CKEDITOR.instances.txtEmailBody.getData();

            if (String.isNullOrEmpty(mailTemplate.mailSubject)) {
                modelAlert('Please enter mail subject.', function () {
                    _txtSubject.focus();
                });
                return;
            }

            if (String.isNullOrEmpty(mailTemplate.templateName)) {
                modelAlert('Please enter mail template Name', function () {
                    _txtTemplateName.focus();
                });
                return;
            }

            if (mailTemplate.panelID < 1) {
                modelAlert('Please select panel.', function () {

                });
                return;
            }

            callback(mailTemplate);
        }


        var saveTemplate = function (btnSave) {
            getPanelTemplateDetails(function (mailTemplate) {
                serverCall('PanelEmailTemplate.aspx/SaveTemplate', { panelMailTemplate: mailTemplate }, function (response) {
                    var responseData = JSON.parse(response);
                    modelAlert(responseData.message, function () {
                        if (responseData.status) {
                            window.location.reload();
                        }
                    });
                });
            });
        }



        var onPanelChange = function (panelID) {
            var data = {
                panelID: panelID,
                templateID: ''
            };
            getPanelEmailTemplate(data, function (response) {
                panelTemplates = response;
                var _temp = $('#template_panelTemplates').parseTemplate(panelTemplates);
                $('#divPanelTemplates').html(_temp);
            });
        }



        var getPanelEmailTemplate = function (data, callback) {
            serverCall('PanelEmailTemplate.aspx/GetPanelEmailTemplate', data, function (response) {
                callback(JSON.parse(response));

            });
        }


        var bindPanelEmailTemplate = function (el, callback) {
            var templateID = Number($(el).closest('tr').find('#tdTemplateID').text());
            var data = {
                panelID: '',
                templateID: templateID
            };
            getPanelEmailTemplate(data, function (response) {
                response = response[0];
                $('#txtSubject').val(response.EmailSubject);
                $('#txtTemplateName').val(response.TemplateName)
                $('#ddlPanel').val(response.PanelID).trigger("chosen:updated");
                CKEDITOR.instances.txtEmailBody.setData(response.EmailBody);
            });

        }



    </script>






    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory textCenter">
            <b>Panel Email Template</b>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Panel</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <%--<asp:DropDownList runat="server" ID="ddlPanel"></asp:DropDownList>--%>
                            <select id="ddlPanel" onchange="onPanelChange(this.value)" ></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Subject
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-13">
                            <input type="text" class="required" id="txtSubject" />
                        </div>
                    </div>

                </div>
                <div class="col-md-1"></div>
            </div>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="col-md-1"></div>
            <div class="col-md-22">
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Add Feild</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <select onchange="addFieldName(this.value)" id="ddlField">
                            
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Template Name</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-13">
                        <input type="text" class="required" id="txtTemplateName" />
                    </div>

                </div>
                <div class="row">
                    <div class="col-md-24">
                        <CKEditor:CKEditorControl ID="txtEmailBody" Toolbar="emptyToolbar" BasePath="~/ckeditor" Height="375px" runat="server" ToolbarBasic="true" ClientIDMode="Static" EnterMode="BR"></CKEditor:CKEditorControl>
                    </div>
                </div>
            </div>
            <div class="col-md-1"></div>
        </div>


        <div class="POuter_Box_Inventory textCenter">
            <input type="button" value="Save" onclick="saveTemplate(this)" class="save margin-top-on-btn" />
        </div>

        <div class="POuter_Box_Inventory textCenter">
            <div class="row">
                <div id="divPanelTemplates" class="col-md-24">

                </div>

            </div>
        </div>




   <script id="template_panelTemplates" type="text/html">
        <table  id="tablePanelTemplates" cellspacing="0" rules="all" border="1" style="width:100%;border-collapse :collapse;">
        <thead>
        <tr id="Tr1">
            <th class="GridViewHeaderStyle" scope="col" >#</th>
            <th class="GridViewHeaderStyle" scope="col" >Template Name</th>
            <th class="GridViewHeaderStyle" scope="col" >Email Subject</th>
            <th class="GridViewHeaderStyle" scope="col" >Edit</th>
        </tr>
            </thead>   
            <tbody>

                <#
                     var dataLength=panelTemplates.length;        
                     var objRow;    
            
                for(var j=0;j<dataLength;j++)
                {
                    objRow = panelTemplates[j];
                #>          
                

                    <tr onmouseover="this.style.color='#00F'"    onMouseOut="this.style.color=''" id="<#=j+1#>"  style='cursor:pointer;'>                            
                                                                         
                        <td class="GridViewLabItemStyle">
                            <#=j+1#>
                        </td>
                        <td class="GridViewLabItemStyle" id="td2" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.TemplateName#></td>
                        <td class="GridViewLabItemStyle" id="td3" style="text-align:center; max-width: 100px; overflow: hidden;text-overflow: ellipsis;white-space: nowrap;" ><#=objRow.EmailSubject#></td>
                        <td class="GridViewLabItemStyle hidden" id="tdTemplateID"><#=objRow.ID#></td>
                        <td class="GridViewLabItemStyle" id="td1">
                            <img src="../../Images/Post.gif" alt="" id="imgSelect" class="paymentSelect" style="cursor:pointer" onclick="bindPanelEmailTemplate(this)"  title="Click To Select"/>
                        </td>
                        
                        </tr>            

            <#}#>            
            </tbody>
         </table>    
    </script>



    </div>
</asp:Content>

