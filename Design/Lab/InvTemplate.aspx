<%@ Page Language="C#" ValidateRequest="false" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" 
    CodeFile="InvTemplate.aspx.cs" Inherits="Design_Lab_InvTemplate"  %>

<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Create Investigation Template<br />
            </b>
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" style="display:none;" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                <div class="row">
                    Select Investigation
                </div>
            </div>
            <div class="row">
                <div class="col-md-3" id="dtDept" runat="server">
                    <label class="pull-left">
                        Department
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="ddlDepartment  chosen-select chosen-container" AutoPostBack="true"
                        Width="200px"  OnSelectedIndexChanged="ddlDepartment_SelectedIndexChanged">
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <label class="pull-left">
                        Investigation
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:DropDownList ID="ddlInvestigation" runat="server" CssClass="ddlInvestigation  chosen-select chosen-container requiredField" AutoPostBack="true"
                        Width="200px"   OnSelectedIndexChanged="ddlInvestigation_SelectedIndexChanged">
                    </asp:DropDownList>
                </div>
                <div class="col-md-5">
                    <%-- <button id="OldPatient"  type="button" onclick="$showOldPatientSearchModel()"  style="width:114px;" >Add Mapping</button>
				  --%>
                    <div id="oldPatientModel" class="modal fade">
	<div class="modal-dialog">
		<div class="modal-content" style="min-width: 900px;max-width:80%">
			<div class="modal-header">
				<button type="button" class="close"  onclick="$closeOldPatientSearchModel()"   aria-hidden="true">&times;</button>
				
                   
                
        <h4 class="modal-title">Add Mapping</h4>
                    
			</div>
			<div class="modal-body">
				 
				<div   class="row">
					<div class="col-md-24" style="border:1px;">
                        <div style="width:100%;background-color:blue;color:white;margin:5px;" >
                         <input type="checkbox" id="chkSelectAll"  /><label>Select All</label>
                           <%--<asp:TextBox ID="TextBox1" runat="server"  AutoPostBack="true" OnTextChanged="TextBox1_TextChanged" onkeyup="_postback()" ></asp:TextBox>
                           --%> </div>
                        <asp:CheckBoxList ID="chkObservationType" runat="server" RepeatColumns="4" RepeatDirection="Horizontal"
                            Width="956px">
                        </asp:CheckBoxList>
                        <input id="txtInvestigationId" runat="server" type="hidden" />
                        <input id="txtTemplateId" runat="server" type="hidden" />
                             </div>
                    </div>
				<div  class="row">
					<div class="col-md-24" style="border:1px;">
                  <%--<div style="text-align:center;border:1px;" class="row">--%>
					   <button type="button"  onclick="addMapping();">Save</button>
				</div>
					</div>
				
          
			</div>
			<div class="modal-footer"> 
				<button type="button"  onclick="$closeOldPatientSearchModel()">Close</button>
			</div>
		</div>
	</div>
</div>
                </div> 
            </div>
            <div class="row"> 
                  <div class="col-md-3">
                    <label class="pull-left">
                        Available Templates
                    </label>
                    <b class="pull-right">:</b>
                </div>
                <div   class="col-md-15">
                    <asp:GridView ID="grdTemplate" runat="server" AutoGenerateColumns="False" 
                        CssClass="GridViewStyle" OnRowCommand="grdTemplate_RowCommand">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="Temp_Head" HeaderText="Template Name">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Investigation" HeaderText="Investigation">
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="350px" />
                            </asp:BoundField>
                            <asp:TemplateField HeaderText="Reject">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbReject" runat="server" CausesValidation="false" CommandArgument='<%#Eval("Template_ID") %>'
                                        CommandName="Reject" ImageUrl="~/Images/Delete.gif" />

                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Edit">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbEdit" runat="server" CausesValidation="False" CommandArgument='<%# Eval("Template_ID") %>'
                                        CommandName="vEdit" ImageUrl="~/Images/edit.png" />

                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Map User">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imbEdit1" runat="server" CausesValidation="False" CommandArgument='<%# Eval("Template_ID") %>'
                                        CommandName="addMapping" ImageUrl="~/Images/edit.png"   />

                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                            </asp:TemplateField>
                        
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

   
    <div class="POuter_Box_Inventory">
        <div class="Purchaseheader">
            <div class="row">New Lab-Observation</div>
        </div>
        <div class="row" style="display: none;">
            Observation Name :
            <input type="button" value="Create New Observation" class="savebutton" style="display: none" onclick="ShowDialog(true);" />

            Observation Name :
            <asp:DropDownList ID="ddlLabObservation" class="ddlLabObservation  chosen-select chosen-container" onchange="getLabObsID();" Width="235px" runat="server">
            </asp:DropDownList>
            &nbsp;&nbsp;&nbsp;
                        Observation ID :&nbsp;
                         <asp:Label ID="lblLabObsID" runat="server"></asp:Label>
        </div>
        <div class="row">
            <div class="col-md-3">
                <label class="pull-left">
                    Template Name
                </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-15">
                <asp:TextBox ID="txtTemplate" runat="Server" CssClass="ItDoseTextinputText requiredField" Visible="true" AutoCompleteType="Disabled" Width="13pc"></asp:TextBox>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <asp:CheckBox ID="chkDefault" runat="server" Text="Set This Template as Default Template" />
            </div>
        </div>
        <div class="row">
            <div class="col-md-3">
                <label class="pull-left">
                    Template Desc
                </label>
                <b class="pull-right">:</b>
            </div>
            <div class="col-md-18">
                <CKEditor:CKEditorControl ID="txtLimit" BasePath="~/ckeditor" runat="server" EnterMode="BR"  ></CKEditor:CKEditorControl>
            </div>
            <div class="col-md-2">
                <%--<input type="button" id="btnsave"  value="Save" style="  width: 56px;    margin-top: 346px;" onclick="savetemplatedata();" />--%>
                <asp:Button ID="btnSave" runat="server" OnClientClick="javascript:return validate();" OnClick="btnSave_Click" Text="Save"   style="  width: 56px;    margin-top: 346px;" /> 
            </div>
        </div> 
    </div>
    <div id="overlay" class="web_dialog_overlay"></div>
    <div id="dialog" class="web_dialog">
        <table style="width: 100%; height: 80px; border: 0px;" cellpadding="3" cellspacing="0" id="tblModifyState">
            <tr>
                <td class="web_dialog_title">Create New Obseravtion</td>
                <td class="web_dialog_title align_right"><a id="btnClose" onclick="HideDialog(true);" style="cursor: pointer;">Close</a></td>
            </tr>
            <tr>
                <td style="text-align: right">Add Observation :&nbsp;
                </td>
                <td>
                    <asp:TextBox ID="txtObservation" runat="server" Width="200px" MaxLength="100"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td style="text-align: right">Short Name :&nbsp;
                </td>
                <td>
                    <asp:TextBox ID="txtObsShortName" runat="server" Width="200px" MaxLength="20"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td style="text-align: right">Suffix :&nbsp;
                </td>
                <td>
                    <asp:TextBox ID="txtObsSuffix" runat="server" Width="200px" MaxLength="10"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td style="text-align: right">
                    <asp:CheckBox ID="chkIsCulture" runat="server" Text="IsCultureReport" />
                </td>
                <td>
                    <asp:CheckBox ID="chkObsAnylRpt" runat="server" Text="Show in Patient Report" />
                </td>
            </tr>
            <tr>
                <td style="text-align: right">Round Off :&nbsp;
                </td>
                <td>
                    <asp:DropDownList ID="ddlRoundOff" runat="server">
                        <asp:ListItem Value="0">0</asp:ListItem>
                        <asp:ListItem Value="1">1</asp:ListItem>
                        <asp:ListItem Value="2" Selected="True">2</asp:ListItem>
                        <asp:ListItem Value="3">3</asp:ListItem>
                        <asp:ListItem Value="4">4</asp:ListItem>
                        <asp:ListItem Value="5">5</asp:ListItem>
                        <asp:ListItem Value="6">6</asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td style="text-align: right">Master Gender :&nbsp;
                </td>
                <td>
                    <asp:DropDownList ID="ddlGender2" runat="server">
                        <asp:ListItem Value="B">Both</asp:ListItem>
                        <asp:ListItem Value="M">Male</asp:ListItem>
                        <asp:ListItem Value="F">Female</asp:ListItem>
                    </asp:DropDownList>
                    <asp:CheckBox ID="chkIPrintSeparateOBS" Text="Print Separate" runat="server" />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:CheckBox ID="chkPrintLabReport" Text="Print Lab Report" Checked="true" runat="server" />
                </td>
                <td>
                    <asp:CheckBox ID="chkAllowDubBooking" Text="Allow Duplicate Booking" runat="server" />
                </td>
            </tr>
            <tr>
                <td style="text-align: center;">
                    <input type="button" value="Save " class="savebutton" onclick="AddnewObservation();" style="width: 90px;" />
                </td>
                <td style="text-align: center;">
                    <input type="button" value="Cancel" class="savebutton" onclick=" HideDialog(true);" style="width: 90px;" /></td>
            </tr>
        </table>

    </div>
         </div>
    <script type="text/javascript">
        function loadUsers() {

            var uid = '';
            $.ajax({

                url: "invtemplate.aspx/FillUsers",
                data: '{}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    result = $.parseJSON(result.d);
                    $('#' + uid).empty();
                    $('#' + uid).append("<option value=''>Select</option>");
                    for (var i = 0; i < result.length; i++) {
                        var newOption = "<option value=" + result[i].Id + ">" + result[i].Name + "</option>";
                        $('#' + uid).append(newOption);
                    }

                },
                error: function (xhr, status) {
                    //alert("Error.... ");
                }
            });

        }
        function loadMapping() {

             $.ajax({

                 url: "invtemplate.aspx/FillMapping",
        data: '{}', // parameter map
        type: "POST", // data has to be Posted    	        
        contentType: "application/json; charset=utf-8",
        timeout: 120000,
        dataType: "json",
        success: function (result) {
  OldPatient = $.parseJSON(result.d);
            var outputPatient = $('#tbl_Mapping').parseTemplate(OldPatient);
            $('#divMapping').html(outputPatient);

        },
        error: function (xhr, status) {
            //alert("Error.... ");
        }
            });

        }
        function insertMapping() {
            var investigationid = $('#' + '').val();
            var templateid = $('#' + '').val();
            var userid = $('#' + '').val();
            $.ajax({

                url: "invtemplate.aspx/InsertMapping",
                data: '{investigationid:"' + investigationid + '",templateid:"' + templateid + '",userid:"'+userid+'"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    result = $.parseJSON(result.d);
                    loadMapping();
                },
                error: function (xhr, status) {
                    //alert("Error.... ");
                }
            });

        }

        function loadTemplateDropDown() {

            var id = '';
            var tid = '';
            $.ajax({

                url: "invtemplate.aspx/FillTemplateDropDown",
                data: '{ InvestigationId:"' + $('#'+id).val() + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    result = $.parseJSON(result.d);
                    $('#' + tid).empty();
                    $('#' + tid).append("<option value=''>Select</option>");
                        for (var i = 0; i < result.length; i++) {
                            var newOption = "<option value=" + result[i].Template_ID + ">" + result[i].Temp_Head + "</option>";
                            $('#' + tid).append(newOption);
                        }
                    
                },
                error: function (xhr, status) {
                    //alert("Error.... ");
                }
            });

        }

       var $showOldPatientSearchModel = function () {
            $('#oldPatientModel .modal-body').find('input[type=text]').not('#txtSearchModelFromDate,#txtSerachModelToDate').val('');
            $('#oldPatientModel').showModel();
        }

       var $closeOldPatientSearchModel = function () {
            $('#oldPatientModel').hideModel();
        }

        function myfunction(aa) {
            modelAlert(aa);
        }
        function savetemplatedata() {
            if ($('#<%=ddlInvestigation.ClientID%>').val() == null || $('#<%=ddlInvestigation.ClientID%>').val() == "") {
                //   lblMsg.Text = "Please Select Investigation..!";
                modelAlert('Please Select Investigation');
                return false;
            }
            if ( $('#<%=txtTemplate.ClientID%>').val() == "") {
                //  lblMsg.Text = "Please Enter Template Name..!";
                modelAlert('Please Enter Template Name');
                return false;
            }
            var txtLimit = "";
            txtLimit = CKEDITOR.instances['<%=txtLimit.ClientID%>'].getData();
            if (txtLimit == "") {
                //lblMsg.Text = "Please Enter Template Text..!";
                modelAlert('Please Enter Template Text');
                return false;
            }
            var DefaultTemplate = jQuery("#<%=chkDefault.ClientID %>").is(':checked') ? 1 : 0;
         //   '" + ddlInvestigation.SelectedValue + "', '" + txtTemplate.Text.Trim() + "', '" + header + "'
            jQuery.ajax({
                url: "InvTemplate.aspx/SaveUpdate",
                data: '{ Status: "' + jQuery("#btnsave").val() + '",InvID: "' + jQuery("#<%=ddlInvestigation.ClientID%>").val() + '",header : "' + txtLimit + '",DefaultTemplate:  "' + DefaultTemplate + '",TemplateName="' + $('#<%=txtTemplate.ClientID%>').val() + '"}', // parameter map
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        resData = jQuery.parseJSON(result.d);
                        if (resData == '0') {
                            
                        }
                        if (resData != "Error") {
                          
                        }
                        else {
                           
                        }

                    },
                    error: function (xhr, status) {
                        modelAlert('Error');
                    }
             });

        }
        $(function () {

            var Investigation_ID = '<%=InvestigationID %>';
                if (Investigation_ID != "0") {
                    $('#ctl00_ddlUserName').hide();
                    $('.Hider').hide();
                }
                else {


                    $('#ctl00_ddlUserName').show();
                    $('.Hider').show();
                }


            });</script>
    <script type="text/javascript">
        function addMapping() {
            var data = new Array();
            $('#'+'<%=chkObservationType.ClientID %>'+' input:checkbox').each(function () {
                var obj = new Object();

               //alert($(this).prop('checked') + $(this).attr('value'));
                obj.Value = $(this).attr('value');
                if ($(this).prop('checked') == true) {
                    obj.Check = "Yes";
                }
                else {

                    obj.Check = "No";
                }
                data.push(obj);
            });
            var PID = $('#'+'<%=txtInvestigationId.ClientID %>').val();
            var TID = $('#'+'<%=txtTemplateId.ClientID %>').val();
                if (data != "") {
                $.ajax({
                    type: "POST",
                    data: JSON.stringify({ Intake: data, PID: PID, TID: TID }),
                    url: "InvTemplate.aspx/saveIntake",
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    timeout: 120000,
                    async: false,
                    success: function (result) {
                        alert('Saved');
                        $closeOldPatientSearchModel();

                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;
                        $("#lblMsg").text('Error occurred, Please contact administrator');
                        $('#btnSave').removeProp('disabled');
                    }

                });
            }
            else
                $("#lblMsg").text('Please Select At Least One CheckBox');

        }
    $(document).ready(function () {
        $('#chkSelectAll').change(function () {
            if (this.checked) {
                $('#' + '<%=chkObservationType.ClientID %>'+' input:checkbox').prop("checked", true);
            }
            else {
                $('#' + '<%=chkObservationType.ClientID %>' + ' input:checkbox').prop("checked", false);
            }

        });
            loadMapping();
            loadUsers();
            BindLabObs();
            var config = {
                '.chosen-select': {},
                '.chosen-select-deselect': { allow_single_deselect: true },
                '.chosen-select-no-single': { disable_search_threshold: 10 },
                '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
                '.chosen-select-width': { width: "95%" }
            }
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        });
        function BindLabObs() {
            ddlLabOBs = $("#<%=ddlLabObservation.ClientID %>");
                $("#<%=ddlLabObservation.ClientID %> option").remove();
                $.ajax({
                    url: "InvTemplate.aspx/BindLabObs",
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    async: false,
                    success: function (result) {
                        LabObsData = jQuery.parseJSON(result.d);
                        if (LabObsData.length > 0) {
                            for (i = 0; i < LabObsData.length; i++) {
                                ddlLabOBs.append($("<option></option>").val(LabObsData[i].LabObservation_ID).html(LabObsData[i].Name));
                            }
                        }
                        $("#<%=ddlLabObservation.ClientID %>").trigger('chosen:updated');
                    },
                    error: function (xhr, status) {
                        modelAlert("Error");
                    }
                });
            }
            function getLabObsID() {
                $('#<%=lblLabObsID.ClientID%>').html('{' + $('#<%=ddlLabObservation.ClientID%>').val() + '}');
            }
    </script>
    <script type="text/javascript">
        $("#btnClose").click(function (e) {
            HideDialog();
            e.preventDefault();
        });
        function HideDialog() {
            $("#overlay").hide();
            $("#dialog").fadeOut(300);
        }
        function ShowDialog(modal, Type) {
            clearData();
            $("#overlay").show();
            $("#dialog").fadeIn(300);
            if (modal) {
                $("#overlay").unbind("click");
            }
            else {
                $("#overlay").click(function (e) {
                    HideDialog();
                });
            }
        }
        function AddnewObservation() {

            var RoundOff = jQuery('#<%=ddlRoundOff.ClientID %>').val();

                if (jQuery.trim(jQuery("#<%=txtObservation.ClientID%>").val()) == "") {
                    modelAlert("Observation Name Cannot be Blank");
                    jQuery("#<%=txtObservation.ClientID%>").focus();
                     return;
                 }


                 if (jQuery("#<%=txtObsSuffix.ClientID%>").val().length > 6) {
                     modelAlert("Suffix Length Cannot Be More Then 6");
                    jQuery("#<%=txtObsSuffix.ClientID%>").focus();
                     return;
                 }


                 var IsCulture = jQuery("#<%=chkIsCulture.ClientID %>").is(':checked') ? 1 : 0;
                var ObsAnylRpt = jQuery("#<%=chkObsAnylRpt.ClientID %>").is(':checked') ? 1 : 0;
                var PrintSeparate = jQuery("#<%=chkIPrintSeparateOBS.ClientID %>").is(':checked') ? 1 : 0;
                var PrintInLab = jQuery("#<%=chkPrintLabReport.ClientID %>").is(':checked') ? 1 : 0;
                var AllowDubB = jQuery("#<%=chkAllowDubBooking.ClientID %>").is(':checked') ? 1 : 0;

                jQuery.ajax({
                    url: "Services/MapInvestigationObservation.asmx/SaveNewObservation",
                    data: '{ ObsName: "' + jQuery("#<%=txtObservation.ClientID %>").val() + '",ShortName: "' + jQuery("#<%=txtObsShortName.ClientID %>").val() + '",Suffix: "' + jQuery("#<%=txtObsSuffix.ClientID %>").val() + '",IsCulture: "' + IsCulture + '",ObsAnylRpt: "' + ObsAnylRpt + '",RoundOff:"' + jQuery("#<%=ddlRoundOff.ClientID %>").val() + '",Gender:"' + jQuery("#<%=ddlGender2.ClientID %>").val() + '",PrintSeparate:"' + PrintSeparate + '",PrintInLabReport:"' + PrintInLab + '",AllowDuplicateBooking:"' + AllowDubB + '"}', // parameter map
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     dataType: "json",
                     success: function (result) {
                         resData = jQuery.parseJSON(result.d);
                         if (resData == '0') {
                             modelAlert('Observation Already Exist');
                             return;
                         }
                         if (resData != "Error") {
                             clearData();
                             BindLabObs();
                             HideDialog();
                         }
                         else {
                             modelAlert('Error Occured....!');
                             return;
                         }

                     },
                     error: function (xhr, status) {
                         modelAlert('Error');
                     }
                 });
             }
             function clearData() {
                 jQuery("#<%=txtObservation.ClientID %>,#<%=txtObsShortName.ClientID %>,#<%=txtObsSuffix.ClientID %>").val('');
    jQuery("#<%=chkIsCulture.ClientID %>,#<%=chkObsAnylRpt.ClientID %>,#<%=chkIPrintSeparateOBS.ClientID %>").prop('checked', false);
    jQuery("#<%=ddlRoundOff.ClientID %>,#<%=ddlGender2.ClientID %>").prop('selectedIndex', 0);
}
    </script>
    <style type="text/css">
        .web_dialog_overlay {
            position: fixed;
            top: 0;
            right: 0;
            bottom: 0;
            left: 0;
            height: 100%;
            width: 100%;
            margin: 0;
            padding: 0;
            background: #000000;
            opacity: 0.65;
            filter: alpha(opacity=15);
            -moz-opacity: .15;
            z-index: 101;
            display: none;
        }

        .web_dialog {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            margin-left: -190px;
            margin-top: -100px;
            background-color: #ffffff;
            border: 2px solid #336699;
            padding: 0px;
            z-index: 102;
            font-family: Verdana;
            font-size: 10pt;
        }

        .web_dialog_title {
            border-bottom: solid 2px #336699;
            background-color: #336699;
            padding: 4px;
            color: White;
            font-weight: bold;
        }

            .web_dialog_title a {
                color: White;
                text-decoration: none;
            }

        .align_right {
            text-align: right;
        }
    </style>
</asp:Content>

