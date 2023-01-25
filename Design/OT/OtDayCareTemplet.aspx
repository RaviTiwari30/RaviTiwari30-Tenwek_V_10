<%@ Page Title="" Language="C#" AutoEventWireup="true" CodeFile="OtDayCareTemplet.aspx.cs" Inherits="Design_OT_OtDayCareTemplet" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/Time.ascx" TagPrefix="ucTime" TagName="Time" %> 

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link href="../../Styles/PurchaseStyle.css" rel="stylesheet" type="text/css" />
    <link rel="Stylesheet" href="../../Styles/framestyle.css" />
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script src="../../Scripts/ipad.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/CPOE_AddToFavorites.js"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/Common.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <div>



         <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Report Template</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError" />&nbsp;              
            </div>
            <div class="POuter_Box_Inventory">
                 <div class="row">
                    <div class="col-md-3" style="display:none" >
                        <label class="pull-left">
                            Temp.Filter 
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6"  style="display:none">
                        <input type="radio" checked="checked" name="rbtnFilterType" onchange="OnFilterTypeChange()" value="Self" />
                        Self &nbsp;
                        <input type="radio" onchange="OnFilterTypeChange()" name="rbtnFilterType" value="All" />
                        All
                    </div>
                    <div class="col-md-15"> </div>
                    
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Type 
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <select id="ddlType"></select>
                    </div>
                    <div class="col-md-6">
                        <input type="button" onclick="openTemplateCreatePopup();" style="width: 200px;" value="Create & Update(Selected) Type" />
                    </div>
                    <div class="col-md-9">
                        <input type="button" id="btnNewConsent" onclick="PatientNewConsent();" style="display: none;" value="New Consent" />
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Template 
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <select id="ddlTemplate" onchange="bindTemplateContent();"></select>
                    </div>
                    <div class="col-md-6">
                        <input type="button" id="btnDeleteTemp" onclick="deleteSelectedTemplate();" style="width: 200px; display:none;" value="Delete Selected Template" />
                    </div>
                    <div class="col-md-9">
                    </div>

                </div>

                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Content 
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-18">
                       <%-- <textarea style="height: 100px" id="txtTemplateContent"></textarea>--%>
                         <CKEditor:CKEditorControl ID="txtTemplateContent" BasePath="~/ckeditor" ClientIDMode="Static" runat="server" EnterMode="BR"></CKEditor:CKEditorControl>
                    </div>
                    <div class="col-md-3">
                    </div>

                </div>
            </div>
            <div id="Div1" class="POuter_Box_Inventory" style="text-align: center;" runat="server">
                <div class="row">
                    <div class="col-md-3"></div>
                    <div class="col-md-3">
                        <input type="button" id="btnSave" onclick="savePatientConsentData();" value="Save" />
                    </div>
                    <div class="col-md-4">
                        <input type="checkbox" id="chkSaveAsTemplate" onchange="showMandatory();" /><b><label class="pull-right patientInfo" style="margin-left: -20px;">Save As Template</label></b>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">
                            Template Name 
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-8">
                        <input type="text" id="txtTemplateName" />
                    </div>
                    <div class="col-md-3"></div>
                </div>
            </div>



            <div id="Div2" class="POuter_Box_Inventory" style="text-align: center;" runat="server">
                <div class="Purchaseheader">Template Details</div>
                <div class="row">
                    <div id="dvPatientDetail"></div>
                </div>
            </div>
            <asp:Label ClientIDMode="Static" runat="server" ID="lblPatientID" Style="display: none"></asp:Label>
            <asp:Label ClientIDMode="Static" runat="server" ID="lblTransactionID" Style="display: none"></asp:Label>
            <asp:Label ClientIDMode="Static" runat="server" ID="lblTypeId" Style="display: none"></asp:Label>
            <asp:Label ClientIDMode="Static" runat="server" ID="lblDoctorID" Style="display: none"></asp:Label>
            <asp:Label ClientIDMode="Static" runat="server" ID="lblConsentID" Style="display: none"></asp:Label>
             <asp:Label ClientIDMode="Static" runat="server" ID="lblApp_ID" Style="display: none"></asp:Label>
            
            <div id="dvCreateAndUpdateConsentType" class="modal fade">
                <div class="modal-dialog">
                    <div class="modal-content" style="background-color: white; width: 40%;">
                        <div class="modal-header">
                            <button type="button" class="close" onclick="closeCreateAndUpdateConsentTypeModel()" aria-hidden="true">×</button>
                            <h4 class="modal-title"><span id="spnHeaderLabel">Create New Type</span> </h4>
                        </div>
                        <div style="max-height: 200px; overflow: auto;" class="modal-body">
                            <div class="row">
                                <div class="col-md-1"></div>
                                <div class="col-md-5">
                                    <label class="pull-left">
                                        Type Name 
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-17">
                                    <input type="text" id="txtTypeName" maxlength="100" />
                                </div>
                                <div class="col-md-1"></div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" id="btnSaveConsentType" onclick="onSaveConsentType(1)">Save</button>
                            <button type="button" id="btnUpdateConsentType" onclick="onSaveConsentType(2)">Update</button>
                            <button type="button" id="btnDeleteConsentType" onclick="onDeleteConsentType()">Delete</button>
                            <button type="button" onclick="closeCreateAndUpdateConsentTypeModel()">Close</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>



        <script type="text/javascript">
            $(document).ready(function () {
                bindConsentType(function () {
                    bindTemplate(function () {
                        bindPatientConsent(function () { });
                    });
                });
            });
            var bindPatientConsent = function (callback) {
                debugger;
                var patientID = $('#lblPatientID').text();
                serverCall('OtDayCareTemplet.aspx/bindPatientConsent', { patientID: patientID }, function (response) {
                    ConsentData = JSON.parse(response);
                    var message = $('#tb_PatientDetail').parseTemplate(ConsentData);
                    $('#dvPatientDetail').html(message);
                    callback(true);
                });
            }
            var bindConsentType = function (callback) {
                var DoctorID = "0";
                var filterType = $('input[name=rbtnFilterType]:checked').val();
                if (filterType != "All")
                    DoctorID = $("#lblDoctorID").text();
                var $ddlType = $('#ddlType');
                serverCall('OtDayCareTemplet.aspx/BindConsentType', { doctorID: DoctorID }, function (response) {
                    $ddlType.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'Name', isSearchAble: true });
                    callback($ddlType.val());

                });
            }
            var bindTemplate = function (callback) {
                var DoctorID = "0";
                var filterType = $('input[name=rbtnFilterType]:checked').val();
                if (filterType != "All")
                    DoctorID = $("#lblDoctorID").text();

                var $ddlTemplate = $('#ddlTemplate');
                serverCall('OtDayCareTemplet.aspx/BindTemplate', { doctorID: DoctorID }, function (response) {
                    $ddlTemplate.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'Template_ID', textField: 'Template_Name', isSearchAble: true });
                    callback($ddlTemplate.val());

                });
            }
            var OnFilterTypeChange = function () {
                bindConsentType(function () {
                    bindTemplate(function () { });
                });
            }


            var bindTemplateContent = function () {
                //  $("#txtTemplateContent").val('');
                CKEDITOR.instances['txtTemplateContent'].setData('');
                var TemplateId = Number($('#ddlTemplate').val());
                if (TemplateId != 0) {
                    serverCall('OtDayCareTemplet.aspx/BindTemplateContent', { templateId: TemplateId }, function (response) {
                        var responseData = JSON.parse(response);
                        //  $("#txtTemplateContent").val(responseData[0].Template_Desc);
                        CKEDITOR.instances['txtTemplateContent'].setData(responseData[0].Template_Desc);
                    });
                    $("#btnDeleteTemp").show();
                }
                else
                    $("#btnDeleteTemp").hide();
            }

            var deleteSelectedTemplate = function () {
                var DoctorID = $("#lblDoctorID").text();
                var TemplateId = Number($('#ddlTemplate').val());
                var TempName = "Template Name : " + $('#ddlTemplate option:selected').text();
                modelConfirmation('Are You Sure to Delete Selected Template ?', TempName, 'Yes', 'No', function (res) {
                    if (res) {
                        serverCall('OtDayCareTemplet.aspx/DeleteSelectedTemplate', { templateId: TemplateId, doctorID: DoctorID }, function (response) {
                            var responseData = JSON.parse(response);
                            if (responseData.status) {
                                modelAlert(responseData.response, function () {
                                    bindTemplate(function () { });
                                });
                            }
                            else
                                modelAlert(responseData.response);

                        });
                    }
                });
            }
            var showMandatory = function () {
                if ($('#chkSaveAsTemplate').is(':checked'))
                    $("#txtTemplateName").addClass("requiredField");
                else
                    $("#txtTemplateName").removeClass("requiredField");
            }
            var onDeleteConsentType = function () {
                modelConfirmation('Are You Sure ?', 'To Delete the Selected Type', 'Yes', 'No', function (res) {
                    if (res) {
                        onSaveConsentType(3);
                    }
                });
            }

            var onSaveConsentType = function (type) {
                if ($("#txtTypeName").val() == "") {
                    $("#txtTypeName").focus();
                    return;
                }

                data = {
                    type: type,
                    typeID: $("#lblTypeId").text(),
                    typeName: $("#txtTypeName").val(),
                    doctorID: $("#lblDoctorID").text()
                }
                serverCall('OtDayCareTemplet.aspx/SaveConsentType', data, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status) {
                        modelAlert(responseData.response, function () {
                            bindConsentType(function () { });
                            $('#dvCreateAndUpdateConsentType').hideModel();
                        });
                    }
                    else
                        modelAlert(responseData.response);
                });
            }


            var onDeletePatientConsent = function (srNo, ID) {
                modelConfirmation('Are You Sure ?', 'To Reject the Consent Form No.' + srNo, 'Yes', 'No', function (res) {
                    if (res) {
                        savePatientConsent(3, ID);
                    }
                });
            }

            var savePatientConsentData = function () {
                var consentId = Number($("#lblConsentID").text());
                if ($("#btnSave").val() == "Save")
                    savePatientConsent(1, 0);
                else
                    savePatientConsent(2, consentId);
            }

            var savePatientConsent = function (type, ID) {

                $("#lblMsg").text("");

                var IsSaveAsTemplate = $('#chkSaveAsTemplate').is(':checked') ? '1' : '0'
                var TemplateName = $("#txtTemplateName").val();

                if (type != 3) {
                    if ($("#ddlType").val() == "0") {
                        $("#ddlType").focus();
                        $("#lblMsg").text("Please Select Type");
                        return;
                    }
                    // if ( $("#txtTemplateContent").val() == "") {
                    if (CKEDITOR.instances['txtTemplateContent'].getData() == "") {
                        //  $("#txtTemplateContent").focus();
                        CKEDITOR.instances['txtTemplateContent'].focus();
                        $("#lblMsg").text("Please Enter Content");
                        return;
                    }
                    if (IsSaveAsTemplate == 1 && TemplateName == "") {
                        $("#txtTemplateName").focus();
                        $("#lblMsg").text("Please Enter Template Name");
                        return;
                    }
                }
                data = {
                    type: type,
                    consentId: ID,
                    transactionId: $("#lblTransactionID").text(),
                    patientID: $("#lblPatientID").text(),
                    typeID: $("#ddlType").val(),
                    //  content: $("#txtTemplateContent").val(''),
                    content: CKEDITOR.instances['txtTemplateContent'].getData(),
                    templateName: TemplateName,
                    isSaveAsTemplate: IsSaveAsTemplate,
                    doctorID: $('#lblDoctorID').text(),
                    appID: Number($('#lblApp_ID').text())

                }
                serverCall('OtDayCareTemplet.aspx/SavePatientConsent', data, function (response) {
                    var responseData = JSON.parse(response);
                    if (responseData.status) {
                        modelAlert(responseData.response, function () {
                            bindPatientConsent(function () {
                                // $("#txtTemplateContent").val('');
                                CKEDITOR.instances['txtTemplateContent'].setData("");
                                $("#btnSave").val('Save');
                                if (IsSaveAsTemplate == 1) {
                                    bindTemplate(function () {
                                        $("#txtTemplateName").val('');
                                        $("#chkSaveAsTemplate").prop("checked", false);
                                    });
                                }
                            });

                        });
                    }
                    else
                        modelAlert(responseData.response);
                });
            }
            var EditConsentForm = function (ctrlId, ID) {
                $("#lblConsentID").text(ID);
                var typeID = $(ctrlId).closest('tr').find('#tdTypeID').html();
                var content = $(ctrlId).closest('tr').find('#tdContent').html();
                // $("#txtTemplateContent").val(content);
                CKEDITOR.instances['txtTemplateContent'].setData(content);
                $("#ddlType").val(typeID).trigger("chosen:updated");
                $("#btnSave").val('Update');
                $("#btnNewConsent").show();
            }
            var printConsentForm = function (ID) {
                window.open('ConsentFormPrintout_Ot.aspx?PcdID=' + ID);

            }


            var PatientNewConsent = function () {
                $("#lblConsentID").text("");
                // $("#txtTemplateContent").val("");
                CKEDITOR.instances['txtTemplateContent'].setData("");
                $("#ddlType").val("0").trigger("chosen:updated");
                $("#btnSave").val('Save');
                $("#btnNewConsent").hide();
            }


            var closeCreateAndUpdateConsentTypeModel = function () {
                $('#dvCreateAndUpdateConsentType').closeModel();
            }
            var openTemplateCreatePopup = function () {

                if ($("#ddlType").val() != "0") {
                    $("#lblTypeId").text($("#ddlType").val());
                    $("#btnSaveConsentType").hide();
                    $("#btnUpdateConsentType,#btnDeleteConsentType").show();
                    $("#txtTypeName").val($("#ddlType option:selected").text());
                    $("#spnHeaderLabel").text("Update & Delete Selected Type");
                }
                else {
                    $("#lblTypeId").text("");
                    $("#btnSaveConsentType").show();
                    $("#btnUpdateConsentType,#btnDeleteConsentType").hide();
                    $("#txtTypeName").val("");
                    $("#spnHeaderLabel").text("Create New Type");
                }
                $('#dvCreateAndUpdateConsentType').showModel();
            }
        </script>
         <script id="tb_PatientDetail" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdPatientDetail" style="width:100%; border-collapse: collapse;">
            <thead>
            <tr id="TrHead">
                <th class="GridViewHeaderStyle" scope="col" >S/No.</th>
                <th class="GridViewHeaderStyle" scope="col" >UHID</th>
                <th class="GridViewHeaderStyle" scope="col" >Patient Name</th>
                <th class="GridViewHeaderStyle" scope="col" >Entry Date</th>
                <th class="GridViewHeaderStyle" scope="col" >Entry By</th>
                <th class="GridViewHeaderStyle" scope="col" >Update Date</th>
                <th class="GridViewHeaderStyle" scope="col" > Updated By</th>
                <th class="GridViewHeaderStyle" scope="col" >Type</th>
                <th class="GridViewHeaderStyle" scope="col"  style="display:none;" >Content</th>
                <th class="GridViewHeaderStyle" scope="col" >Edit</th>
                <th class="GridViewHeaderStyle" scope="col" >Reject</th>
                <th class="GridViewHeaderStyle" scope="col" >Print</th>
                <th class="GridViewHeaderStyle" scope="col" style="display:none;" ></th>

                
            </tr>
                </thead><tbody>
        <#       
        var dataLength=ConsentData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {       
        objRow = ConsentData[j];
        #>
               <tr id="TrBody" >        
                    <td class="GridViewLabItemStyle" style="text-align:center"><#=j+1#></td>
                   <td class="GridViewLabItemStyle" style="text-align:center"><#=objRow.Patient_ID #></td>
                   <td class="GridViewLabItemStyle" style="text-align:left; width:200px;"><#=objRow.PatientName #></td>
                   <td class="GridViewLabItemStyle" style="text-align:center ;width:100px;"><#=objRow.EntryDate #></td>
                   <td class="GridViewLabItemStyle" style="text-align:center ;width:100px;"><#=objRow.EntryBy #></td>
                   <td class="GridViewLabItemStyle" style="text-align:center ;width:100px;"><#=objRow.UpdatedDate #></td>
                   <td class="GridViewLabItemStyle" style="text-align:center ;width:100px;"><#=objRow.UpdatedBy #></td>
                   <td class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.ConsentType #></td>
                   <td class="GridViewLabItemStyle" id="tdContent" style="text-align:left;display:none;"><#=objRow.Content #></td>
                   
                   <td class="GridViewLabItemStyle" style="text-align:center">
                         <# if ( objRow.Timehours <= 23 ){#>
                     <img alt="Edit" title="Edit" onclick="EditConsentForm(this,'<#=objRow.ID #>')" style="display:<#=objRow.IsVisible #>;" src="../../Images/edit.png" />
                        <#}#>
                         
                    </td>
                    <td class="GridViewLabItemStyle" style="text-align:center">
					     <# if ( objRow.Timehours <= 23 ){#>
                    <img alt="Reject" title="Reject" onclick="onDeletePatientConsent('<#=j+1#>','<#=objRow.ID #>')" style="display:<#=objRow.IsVisible #>;" src="../../Images/Delete.gif" />
						  <#}#>
                    </td>
                    <td class="GridViewLabItemStyle" style="text-align:center">
                         <img alt="Print" title="Print" src="../../Images/print.gif" onclick="printConsentForm('<#=objRow.ID #>')" />
                    </td>
                     <td class="GridViewLabItemStyle" id="tdTypeID" style="display:none;"><#=objRow.TypeID#></td>

               </tr>           
        <#}#>   
            </tbody>    
     </table>    
    </script>
    </div>


        </form>
</body>
</html>