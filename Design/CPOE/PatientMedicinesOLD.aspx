﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientMedicinesOLD.aspx.cs"
    Inherits="Design_CPOE_PatientMedicines" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Controls/PatientDiagnosis.ascx" TagName="PatientDiagnosis"
    TagPrefix="uc3" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" />
    <%--<link rel="stylesheet" href="../../Styles/PurchaseStyle.css" />--%>
    <script type="text/javascript" src="../../Scripts/Search.js"></script>
    <script src="../../Scripts/jquery-1.7.1.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/jquery-ui.js"></script>
    <script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/json2.js"></script>
    <script type="text/javascript">
        function RestrictDoubleEntry(btn) {
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('btnSave', '');
        }
        var keys = [];
        var values = [];
        $(document).ready(function () {
            $('#<%=txtInBetweenSearch.ClientID%>').focus();
            var options = $('#<% = lstInv.ClientID %> option');
            $.each(options, function (index, item) {
                keys.push(item.value);
                values.push(item.innerHTML);
            });

            $('#<% = txtSearch.ClientID %>').keyup(function (e) {
                searchByFirstChar(document.getElementById('<%=txtSearch.ClientID%>'), document.getElementById('<%=txtcpt.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=lstInv.ClientID%>'), document.getElementById('btnSelect'), values, keys, e)
                findDose();
            });
            $('#<%=txtcpt.ClientID %>').keyup(function (e) {
                searchByCPTCode(document.getElementById('<%=txtSearch.ClientID%>'), document.getElementById('<%=txtcpt.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=lstInv.ClientID%>'), document.getElementById('btnSelect'), values, keys, e)
                findDose();
            });
            $('#<%=txtInBetweenSearch.ClientID %>').keyup(function (e) {
                searchByInBetween(document.getElementById('<%=txtSearch.ClientID%>'), document.getElementById('<%=txtcpt.ClientID%>'), document.getElementById('<%=txtInBetweenSearch.ClientID%>'), document.getElementById('<%=lstInv.ClientID%>'), document.getElementById('btnSelect'), values, keys, e)
                findDose();
            });


        });
        function findDose() {
            var MedicineID = $('#<%=lstInv.ClientID%> option:selected').val().split('#')[0];
            var radios = $.trim($("#<%=rdoType.ClientID%> input[type=radio]:checked").val())
            if (radios == 1)
                $('#<%=txtDose.ClientID %>').val($('#<%=lstInv.ClientID%> option:selected').val().split('#')[2]);
               else
                   $('#<%=txtDose.ClientID %>').val($('#<%=lstInv.ClientID%> option:selected').val().split('#')[3]);
               MedicineStock();
           }
           $(document).ready(function () {
               var patientID = '<%=ViewState["PID"]%>';
            LoadMedicineSet();
        });
            function MedicineStock() {
                var MedicineID = $('#<%=lstInv.ClientID%> option:selected').val().split('#')[0];
            var radios = $.trim($("#<%=rdoType.ClientID%> input[type=radio]:checked").val())
            if (radios == 1)
                $('#<%=txtDose.ClientID %>').val($('#<%=lstInv.ClientID%> option:selected').val().split('#')[2]);
               else
                   $('#<%=txtDose.ClientID %>').val($('#<%=lstInv.ClientID%> option:selected').val().split('#')[3]);
               $.ajax({
                   url: '../Common/CommonService.asmx/GetMedicineStock',
                   data: '{MedicineID:"' + MedicineID + '"}',
                   type: 'Post',
                   contentType: 'application/json; charset=utf-8',
                   dataType: 'json',
                   success: function (result) {
                       DeptLedStock = jQuery.parseJSON(result.d);
                       if (result.d != '' && result.d != null) {
                           var Output = $('#sc_Deptstock').parseTemplate(DeptLedStock);
                           $('#divDeptStock').html(Output);
                           $('#divDeptStock').show();
                       }
                       else {
                           $('#divDeptStock').hide();
                       }

                   },
                   error: function (xhr, status) {
                       window.status = status + "\r\n" + xhr.responseText;
                   }
               });
           }
           function closeAllergies() {
               $find('mpAllergies').hide();
           }
           function CurrentDeptStock() {
               $('#<%=lstInv.ClientID%>').change(function () {

                var MedicineID = ($(this).val()).split('#')[0];
                var radios = $.trim($("#<%=rdoType.ClientID%> input[type=radio]:checked").val())
                if (radios == 1)
                    $('#<%=txtDose.ClientID %>').val(($(this).val()).split('#')[2]);
                else
                    $('#<%=txtDose.ClientID %>').val(($(this).val()).split('#')[3]);

                $.ajax({
                    url: '../Common/CommonService.asmx/GetMedicineStock',
                    data: '{MedicineID:"' + MedicineID + '"}',
                    type: 'Post',
                    contentType: 'application/json; charset=utf-8',
                    dataType: 'json',
                    success: function (result) {
                        DeptLedStock = jQuery.parseJSON(result.d);
                        if (result.d != '' && result.d != null) {
                            var Output = $('#sc_Deptstock').parseTemplate(DeptLedStock);
                            $('#divDeptStock').html(Output);
                            $('#divDeptStock').show();
                        }
                        else {
                            $('#divDeptStock').hide();
                        }

                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;
                    }

                });

            });
        }
        $(document).ready(function () {
            $("#<%=lstInv.ClientID %> option").each(function () {
                if ($(this).val().split('#')[1] == "1") {
                    $(this).css('color', 'blue');
                }
            });
        });
    </script>
    <script type="text/javascript">
        function ValidateCharactercount(charlimit, cont) {
            var id = "#" + cont.id;
            if ($(id).text().length > charlimit) {
                $(id).text($(id).text().substring(0, charlimit));
            }
        }
        function validate() {
            if ($("#<%=lstInv.ClientID %> option:selected").text() == "") {
                $("#<%=lblMsg.ClientID %>").text('Please Select Medicine');
                return false;
            }
            document.getElementById('<%=btnAdd.ClientID%>').disabled = true;
            __doPostBack('btnAdd', '');
        }
    </script>
    <script type="text/javascript">
        function LoadMedicineSet() {
            jQuery("#ddlMedicineset option").remove();
            $.ajax({
                url: "../Common/CommonService.asmx/LoadMedicineSet",
                data: '{DoctorID:"' + $("#<%=lblDoctor.ClientID%>").text() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = jQuery.parseJSON(mydata.d);
                    if (data != null) {
                        jQuery("#ddlMedicineset").append(jQuery("<option></option>").val('0').html("--Select--"));
                        for (var i = 0; i < data.length; i++) {
                            $('#ddlMedicineset').append($("<option></option>").val(data[i].ID).html(data[i].SetName));
                        }
                    }
                }
            });
        }
        function LoadMedSetItems() {
            $.ajax({
                type: "POST",
                data: '{SetID:"' + $('#ddlMedicineset').val() + '"}',
                url: "../Common/CommonService.asmx/LoadMedSetItems",
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                timeout: 120000,
                async: false,
                success: function (result) {
                    PatientData = jQuery.parseJSON(result.d);
                    if (PatientData != null) {
                        var output = $('#tb_PatientMedicineSearch').parseTemplate(PatientData);
                        $('#PatientMedicineSearchOutput').html(output);
                        $('#PatientMedicineSearchOutput').show();
                        $('#btnSaveSet').show();
                        BindDropdown();
                    }
                    else {
                        $('#PatientMedicineSearchOutput').html();
                        $('#PatientMedicineSearchOutput').hide();
                        $('#btnSaveSet').hide();
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $("#debugArea").html("");
                    $("#lblMsg").text('Error occurred, Please contact administrator');
                }

            });
        }

        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find('mpe2')) {
                    $find('mpe2').hide();
                }
                if ($find('mpAllergies')) {
                    closeAllergies();
                }
            }
        }
        function closePatientDetail() {
            $find("mpe2").hide();
        }
        function SaveSetItem() {

            if ($("#ddlMedicineset").val() != "0") {
                var data = new Array();
                var Obj = new Object();
                jQuery("#Table1 tr").each(function () {

                    var id = jQuery(this).attr("id");
                    var $rowid = jQuery(this).closest("tr");
                    if (id != "Tr1") {
                        if ($(this).find("#chkSelect").is(":checked")) {
                            Obj.ItemID = jQuery.trim($rowid.find("#tdItemID").text());
                            Obj.MedicineName = jQuery.trim($rowid.find("#tdItemName").text());
                            Obj.Dose = jQuery.trim($rowid.find("#txtsetDose").val());
                            Obj.Time = jQuery.trim($rowid.find("#ddlsetTime").val().split('#')[1]);
                            Obj.Duration = jQuery.trim($rowid.find("#ddlSetDuration").val().split('#')[1]);
                            Obj.OrderQuantity = jQuery.trim($rowid.find("#txtQty1").val());
                            Obj.Meal = jQuery.trim($rowid.find("#ddlFoodType").val());
                            Obj.TID = '<%=ViewState["TID"] %>';
                             Obj.PID = '<%=ViewState["PID"]%>';
                             Obj.LnxNo = '<%=Request.QueryString["LnxNo"]%>';
                             Obj.Doc = '<%=lblDoctor.Text%>';
                             data.push(Obj);
                             Obj = new Object();
                         }
                     }
                 });

                 if (data.length > 0) {
                     $.ajax({
                         url: "Services/Cpoe_CommonServices.asmx/InsertMedicineSet",
                         data: JSON.stringify({ Data: data }),
                         type: "POST",
                         contentType: "application/json; charset=utf-8",
                         timeout: 120000,
                         async: true,
                         dataType: "json",
                         success: function (result) {
                             Data = result.d;
                             if (Data == "1") {
                                 $(this).find("#chkSelect").attr('checked', false);
                                 window.location.reload(true);
                                 $('#lblMsg').text('Record Saved Successfully');
                                 $find("mpe2").hide();
                                 // EditItem();

                             }
                             else {
                                 //  DisplayMsg('MM124', 'spnMsg');
                             }
                             $("#btnSave").attr('disabled', false);
                         },
                         error: function (xhr, status) {
                             alert(status + "\r\n" + xhr.responseText);
                             // DisplayMsg('MM05', 'spnMsg');
                             $("#btnSave").attr('disabled', false);
                             window.status = status + "\r\n" + xhr.responseText;
                         }
                     });
                 }
             }
             else {
                 var data = new Array();
                 var Obj = new Object();
                 jQuery("#Table2 tr").each(function () {

                     var id = jQuery(this).attr("id");
                     var $rowid = jQuery(this).closest("tr");
                     if (id != "Tr2") {
                         if ($(this).find("#chkLSelect").is(":checked")) {
                             Obj.ItemID = jQuery.trim($rowid.find("#tdLitemid").text());
                             Obj.MedicineName = jQuery.trim($rowid.find("#tdLItemname").text());
                             Obj.Dose = jQuery.trim($rowid.find("#txtLDose").val());
                             Obj.Time = jQuery.trim($rowid.find("#ddlLTime").val().split('#')[1]);
                             Obj.Duration = jQuery.trim($rowid.find("#ddlLDuration").val().split('#')[1]);
                             Obj.Meal = jQuery.trim($rowid.find("#ddlLVisitMeal").val());
                             Obj.OrderQuantity = jQuery.trim($rowid.find("#txtLOrderQuantity").val());
                             Obj.TID = '<%=Request.QueryString["TID"] %>';
                            Obj.PID = '<%=Request.QueryString["PID"]%>';
                            Obj.LnxNo = '<%=Request.QueryString["LnxNo"]%>';
                            Obj.Doc = '<%=lblDoctor.Text%>';
                            data.push(Obj);
                            Obj = new Object();
                        }
                    }
                });

                if (data.length > 0) {
                    $.ajax({
                        url: "Services/Cpoe_CommonServices.asmx/InsertMedicineSet",
                        data: JSON.stringify({ Data: data }),
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        async: true,
                        dataType: "json",
                        success: function (result) {
                            Data = result.d;
                            if (Data == "1") {
                                $(this).find("#chkLSelect").attr('checked', false);
                                window.location.reload(true);
                                $('#lblMsg').text('Record Saved Successfully');
                                $find("mpe2").hide();
                                // EditItem();

                            }
                            else {
                                //  DisplayMsg('MM124', 'spnMsg');
                            }
                            $("#btnSave").attr('disabled', false);
                        },
                        error: function (xhr, status) {
                            alert(status + "\r\n" + xhr.responseText);
                            // DisplayMsg('MM05', 'spnMsg');
                            $("#btnSave").attr('disabled', false);
                            window.status = status + "\r\n" + xhr.responseText;
                        }
                    });
                }
            }
        }
        function chkMedicineType() {
            if ($("#rdoset").is(":checked")) {
                $('#ddlMedicineset').val(0).removeAttr('disabled');
            }
            else {
                $('#ddlMedicineset').val(0).attr('disabled', 'disabled');
                // LoadMedSetItems();
                LastVisitMedicine();
            }
        }
        function LastVisitMedicine() {
            var PID = '<%=Request.QueryString["PID"]%>';
             $.ajax({
                 type: "POST",
                 data: '{PID:"' + PID + '"}',
                 url: "Services/Cpoe_CommonServices.asmx/bindLastVisitMedicine",
                 dataType: "json",
                 contentType: "application/json;charset=UTF-8",
                 timeout: 120000,
                 async: false,
                 success: function (result) {
                     LastVisitsData = jQuery.parseJSON(result.d);
                     if (LastVisitsData != null) {
                         var output = $('#tb_lastVisit').parseTemplate(LastVisitsData);
                         $('#PatientMedicineSearchOutput').html(output);
                         $('#PatientMedicineSearchOutput').show();
                         $('#btnSaveSet').show();

                     }
                     else {
                         $('#PatientMedicineSearchOutput').html();
                         $('#PatientMedicineSearchOutput').hide();
                         $('#btnSaveSet').hide();
                     }
                 },
                 error: function (xhr, status) {
                     window.status = status + "\r\n" + xhr.responseText;
                     $("#lblMsg").text('Error occurred, Please contact administrator');
                 }

             });
         }
         function bindDuration() {
             jQuery("#Table2 tr").each(function () {
                 var id = jQuery(this).attr("id");
                 var $rowid = jQuery(this).closest("tr");
                 if (id != "Tr2") {
                     if (jQuery.trim($rowid.find("#spnLduration").text()) != "")
                         jQuery.trim($rowid.find("#ddlLDuration").val(jQuery.trim($rowid.find("#spnLduration").text())));
                     if (jQuery.trim($rowid.find("#spnLvisitmeal").text()) != "")
                         jQuery.trim($rowid.find("#ddlLVisitMeal").text(jQuery.trim($rowid.find("#spnLvisitmeal").text())));
                     if (jQuery.trim($rowid.find("#spnLTime").text()) != "")
                         jQuery.trim($rowid.find("#ddlLTime").text(jQuery.trim($rowid.find("#spnLTime").text())));
                 }
             });
         }
         function AddInvestigation(sender, evt) {
             if (evt.keyCode > 0) {
                 keyCode = evt.keyCode;
             }
             else if (typeof (evt.charCode) != "undefined") {
                 keyCode = evt.charCode;
             }
             if (keyCode == 13) {
                 $find('mpe2').hide();
                 document.getElementById('btnAdd').click();
             }
         }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>&nbsp;Medicine</b><br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                <table style="width: 100%;border-collapse:collapse">
                    <tr style="display:none;">
                        <td style="text-align: right;width: 180px;">
                            <asp:Label ID="lblWeight" runat="server" CssClass="ItDoseLabelBl"></asp:Label>
                        </td>
                        <td style="text-align: left" colspan="3">
                            <asp:Button ID="btnNewMed" runat="server" Text="New Medicine" CssClass="ItDoseButton"
                                OnClick="btnNewMed_Click" Width="128px" ToolTip="Enter To Add New Medicine" />
                        </td>
                        <td style="text-align: right" colspan="2"></td>
                        <td style="text-align: left" colspan="2"></td>
                    </tr>
                    <tr>
                        <td style="text-align: center" colspan="2">
                           <asp:RadioButtonList ID="rdoType" runat="server" AutoPostBack="True" OnSelectedIndexChanged="rdoType_SelectedIndexChanged"
                                RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True" Value="0">Item Wise</asp:ListItem>
                                <asp:ListItem Value="1">Generic Wise</asp:ListItem>
                            </asp:RadioButtonList>
                        </td>
                        <td style="text-align: left" colspan="3">&nbsp;</td>
                        <td style="text-align: right" colspan="4"> <asp:Button ID="btnSetItem1" runat="server" CssClass="ItDoseButton" Text="Prescribe Medicine Set / Last Visit Medicine"/>
               <cc1:ModalPopupExtender ID="mpe2" runat="server" DropShadow="true" 
        popupdraghandlecontrolid="PopupHeader" Drag="true"   CancelControlID="btncancel1" PopupControlID="pnPreviousVisit"
        TargetControlID="btnSetItem1" BehaviorID="mpe2">
    </cc1:ModalPopupExtender>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right;width: 180px;" >Search By First Name :&nbsp;</td>
                        <td style="text-align: left" colspan="3">
                            <asp:TextBox ID="txtSearch" runat="server" Width="250px"  TabIndex="1"  CssClass="ItDoseTextinputText" AutoCompleteType="Disabled"
                                ToolTip="Enter To Search" />
                        </td>
                        <td style="text-align: right" colspan="2"> CPT Code :&nbsp;</td>
                        <td style="text-align: left" colspan="2">
                        <asp:TextBox ID="txtcpt" runat="server" Width="118px"  CssClass="ItDoseTextinputText" AutoCompleteType="Disabled" />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right;width: 180px;" >&nbsp;&nbsp;Search By Any Name :&nbsp;</td>
                        <td style="text-align: left" colspan="3">

                            <asp:TextBox ID="txtInBetweenSearch" runat="server" CssClass="ItDoseTextinputText" AutoCompleteType="Disabled"
                                Width="250px" TabIndex="1" />
                        </td>
                        <td style="text-align: right" colspan="2">&nbsp;</td>
                        <td style="text-align: left" colspan="2">
                           
                        </td>
                    </tr>
                    <tr>
                        <td  style="text-align: right;width: 180px;vertical-align:top" >Medicine :&nbsp;
                        </td>
                        <td colspan="6">
                            <asp:ListBox ID="lstInv" runat="server" Width="400px" ClientIDMode="Static" onchange="findDose();"
                                Height="121px" ></asp:ListBox>   
                            <span style="color: Red; font-size: 8px">*</span>
                             <asp:Button ID="btnHidden" runat="server" Text="Button" Style="display: none" CssClass="ItDoseButton"/>
                         <asp:Panel ID="pnPreviousVisit" runat="server" CssClass="pnlItemsFilter" style=" display:none;
        width: 970px; height: 350px;">
        <div>
                        <div class="Purchaseheader" style="text-align: left;">
                   Medicine Set And Previous Visit&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
             &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <em ><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor:pointer"  onclick="closePatientDetail()" onkeypress="onKeyDown();"/>                               
                                to close</span></em>
                </div>
            <div><table><tr><td>Type :&nbsp;</td><td><input type="radio" id="rdoset" value="Set" name="Select" checked="checked" onclick="chkMedicineType()"/>Prescribe Set
                <input type="radio" id="rdoLastVisit" value="Last" name="Select" onclick="chkMedicineType()"/>Last Visit Medicine</td>
                <td>Select Set :&nbsp;</td><td> <select id="ddlMedicineset" style="width:225px" onchange="LoadMedSetItems()"></select> </td></tr></table></div>
                                <table  style="width: 100%; border-collapse:collapse">
                <tr style="text-align:center">
                    <td colspan="4">
                        <div id="PatientMedicineSearchOutput" style="height:300px; overflow-y:scroll;overflow:scroll" >
                        </div>
                    </td>
                </tr>
            </table>
    <div>
          <table style="text-align:center">
              <caption>
                  <asp:Button ID="btncancel1" runat="server" CssClass="ItDoseButton" style="display:none" Text="Cancel" />
              </caption>
          </table>
      </div>
          </div>
                          <div style="text-align:center"> <input id="btnSaveSet" value="Save"  type="button" class="ItDoseButton" style="display:none" onclick="SaveSetItem();"/></div>
    </asp:Panel>
                             
                        </td>
                        <td style="vertical-align:top"  ><div id="divDeptStock" style="text-align:left">
                            </div> </td>
                    </tr>
                    </table>
                    <table>
                      
                    <tr>
                        <td style="width:100px"></td>
                        <td style="text-align: right" class="style2">Dose :&nbsp;
                        </td>
                        <td style="width: 5px;">
                            <asp:TextBox ID="txtDose" runat="server" Width="70px" ToolTip="Add Dose" onkeypress="AddInvestigation(this,event);"  
                                TabIndex="2">
                            </asp:TextBox>
                            
                        </td>
                        <td style="text-align:right;width: 57px;">Times :&nbsp;
                        </td>
                        <td style="text-align:left">
                       <asp:DropDownList ID="ddlTime" runat="server" Width="90" ToolTip="Select Time" ClientIDMode="Static" onchange="QuantityCal();" TabIndex="3">
                                    </asp:DropDownList>
                        </td>
                        <td style="text-align: right;width: 73px;">Duration :&nbsp;
                        </td>
                        <td style="text-align: left;width: 31px;">
                            <asp:DropDownList ID="ddlDays" runat="server" ToolTip="Select Days" ClientIDMode="Static" Width="59" onkeypress="AddInvestigation(this,event);" onchange="QuantityCal();" TabIndex="4">
                            </asp:DropDownList>
                            
                            </td>
                        <td  style="text-align:right;width: 46px;">Meal :</td>
                        <td style="text-align: left;width: 40px;">
                            <asp:DropDownList ID="ddlMeal" runat="server" Width="59" TabIndex="5" >
                            <asp:ListItem Value=""></asp:ListItem>
                             <asp:ListItem Value="Before Meal" Selected="True">Before Meal</asp:ListItem>
                            <asp:ListItem Value="After Meal">After Meal</asp:ListItem>
                                                                  </asp:DropDownList>
                            
                        </td>
                        <td>
                            Quantity :</td>
                        <td style="text-align:left">
                            <asp:TextBox ID="txtquantity" runat="server" Width="50px" ClientIDMode="Static" Text="1" onkeypress="return checkForSecondDecimal(this,event)" TabIndex="6"></asp:TextBox>
                        </td>
                    </tr>

                    <tr>

                        <td style="text-align: right" class="style2">Remark :&nbsp;
                        </td>
                        <td colspan="9">
                            <asp:TextBox ID="txtRemarks" runat="server" Width="393px" MaxLength="100" onkeypress="AddInvestigation(this,event);"
                                ToolTip="Enter Remarks" TabIndex="7" />&nbsp;
                        <asp:Button ID="btnAdd" Text="Add" runat="server" CssClass="ItDoseButton"
                            OnClick="btnAdd_Click"  OnClientClick="return validate();" ToolTip="Click To Add" TabIndex="8" />
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:Button ID="btnPrint" runat="server" Text="Print" CssClass="ItDoseButton" OnClick="btnPrint_Click" />&nbsp;
                            <asp:Label ID="lblDoctor" runat="server" ClientIDMode="Static" style="display:none"></asp:Label>
                            <asp:Button ID="btnCreateDiagnosis" runat="server" CssClass="ItDoseButton" Text="View Diagnosis/Allergies" style="display:none" />
                            <input id="btnDiagnosisCancel" class="ItDoseButton" style="display:none" type="button" /> &nbsp;<cc1:ModalPopupExtender ID="mpAllergies" runat="server" BackgroundCssClass="filterPupupBackground" BehaviorID="mpAllergies" CancelControlID="btnDiagnosisCancel" DropShadow="true" PopupControlID="pnlAllergies" PopupDragHandleControlID="Div2" TargetControlID="btnCreateDiagnosis">
                            </cc1:ModalPopupExtender>
                            <asp:Panel ID="pnlAllergies" runat="server" CssClass="pnlItemsFilter" Style="display: none" Width="660px">
                                <div class="Purchaseheader">
                                    <b></b>&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <em><span style="font-size: 7.5pt">Press esc or click
                            <img src="../../Images/Delete.gif" style="cursor:pointer"  onclick="closeAllergies()"/> to close </span></em>
                                </div>
                                 <uc3:PatientDiagnosis ID="PatientDiagnosis" runat="server" />
                            </asp:Panel>
                        </td>
                    </tr>
                </table>
                <div class="Purchaseheader" style="text-align: left;">
                    &nbsp;Medicines
                </div>
                <div style="text-align: center">
                    <asp:GridView ID="grdMedicine" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                        OnRowCommand="grdMedicine_RowCommand" OnRowDataBound="grdMedicine_RowDataBound">
                        <Columns>
                            <asp:TemplateField HeaderText=" S.No." HeaderStyle-Width="35px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Medicine Name" HeaderStyle-Width="250px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblMedicine" runat="server" Text='<%#Eval("Medicine") %>'></asp:Label>
                                    <asp:TextBox ID="txtMedicine" AutoCompleteType="Disabled" MaxLength="50" Visible="false" runat="server" Text='<%#Eval("Medicine") %>'></asp:TextBox>

                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Dose" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblDose" runat="server" Text=' <%#Eval("Dose")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Times" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblTimes" runat="server" Text=' <%#Eval("Time") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                              <asp:TemplateField HeaderText="Meal" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblMeal" runat="server" Text=' <%#Eval("Meal") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Duration" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblDays" runat="server" Text=' <%#Eval("Days") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                              <asp:TemplateField HeaderText="Quantity" HeaderStyle-Width="50px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblQuantity" runat="server" Text=' <%#Eval("Quantity") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Remark" HeaderStyle-Width="290px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:Label ID="lblRemarks" runat="server" Text=' <%#Eval("Remarks")%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Outsource" Visible="false">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                                <ItemTemplate>
                                    <asp:CheckBox ID="chkPrint" runat="server" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Reject" HeaderStyle-Width="45px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imgRemove" runat="server" ImageUrl="~/Images/Delete.gif" CommandName="imbRemove"
                                        CommandArgument='<%#Container.DataItemIndex %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="ID" Visible="false">
                                <ItemStyle HorizontalAlign="Center" CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                                <ItemTemplate>
                                    <asp:Label ID="lblid" Visible="false" runat="server" Text='<%# Eval("MedicineID") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <asp:Button ID="btnSave" runat="server" Text="Save" CssClass="ItDoseButton"
                        OnClick="btnSave_Click" Visible="False" TabIndex="7" ToolTip="Click To Save" OnClientClick="return RestrictDoubleEntry(this)" />
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Patient Prescribed Medicine
                </div>
                <div style="text-align: center;">
                    <asp:GridView ID="grdPreMedicine" runat="server" CssClass="GridViewStyle" AutoGenerateColumns="False" OnRowCommand="grdPreMedicine_RowCommand">
                        <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate>
                                    <%# Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="45px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Medicine Name">
                                <ItemTemplate>
                                    <%# Eval("Item") %>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="320px" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Dose">
                                <ItemTemplate>
                                    <asp:Label ID="lblDose" runat="server" Text='<%# Eval("Dose") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Times">
                                <ItemTemplate>
                                    <asp:Label ID="lblNoTimesDay" runat="server" Text='<%# Eval("NoTimesDay") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                            </asp:TemplateField>
                             <asp:TemplateField HeaderText="Meal">
                                <ItemTemplate>
                                    <asp:Label ID="lblMealSave" runat="server" Text='<%# Eval("Meal") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Duration">
                                <ItemTemplate>
                                    <asp:Label ID="lblNoOfDays" runat="server" Text='<%# Eval("NoOfDays") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                            </asp:TemplateField>
                             <asp:TemplateField HeaderText="Quantity">
                                <ItemTemplate>
                                    <asp:Label ID="lblOrderQuantity" runat="server" Text='<%# Eval("OrderQuantity") %>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Remarks">
                                <ItemTemplate>
                                    <asp:Label ID="lblRemarks" runat="server" Text='<%# Eval("Remarks")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="300px" />
                            </asp:TemplateField>
                             <asp:TemplateField HeaderText="Date">
                                <ItemTemplate>
                                    <asp:Label ID="lblDate" runat="server" Text='<%# Eval("Date")%>'></asp:Label>
                                </ItemTemplate>
                                <ItemStyle CssClass="GridViewItemStyle" />
                                <HeaderStyle CssClass="GridViewHeaderStyle" Width="150px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Reject" HeaderStyle-Width="45px" ItemStyle-CssClass="GridViewItemStyle"
                                HeaderStyle-CssClass="GridViewHeaderStyle">
                                <ItemTemplate>
                                    <asp:ImageButton ID="imgRemove" runat="server" ImageUrl="~/Images/Delete.gif" CommandName="imbRemove"
                                        CommandArgument='<%# Eval("PatientMedicine_ID") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>
                    </asp:GridView>


                </div>
            </div>
            <asp:Panel ID="pnlItem" Width="400px" Height="100px" runat="server" CssClass="pnlRequestItemsFilter"
                Style="display: none">
                <div class="Purchaseheader" runat="server" id="dragHandle">
                    Add Items
                </div>
                <div style="display: none">
                    <asp:Button ID="btnItem" Text="Item" runat="Server" CssClass="ItDoseButton" />
                </div>
                <div>
                    <label class="forItemLabel">
                        Item :</label>
                    <asp:DropDownList ID="ddlItems" runat="server" Width="350px" />
                    <br />
                    <asp:Button ID="btnSaveMed" runat="server" Text="Save" CssClass="ItDoseButton" Width="75px"
                        OnClick="btnSaveMed_Click" />
                    <asp:Button ID="btnCancel" Text="Cancel" runat="server" CssClass="ItDoseButton" Width="75px" />
                </div>
            </asp:Panel>
            <cc1:ModalPopupExtender ID="mpeItems" runat="server" CancelControlID="btnCancel"
                DropShadow="true" TargetControlID="btnItem" BackgroundCssClass="filterPupupBackground"
                PopupControlID="pnlItem" PopupDragHandleControlID="dragHandle" />
            <asp:Panel ID="pnlMed" Width="460px" Height="100px" runat="server" CssClass="pnlRequestItemsFilter" Visible="false"
                Style="display: none">
                <div class="Purchaseheader" runat="server" id="Div1">
                    Add New Medicine&nbsp;
                </div>
                <div style="display: none">
                    <asp:Button ID="btnNM" Text="Item" runat="server" CssClass="ItDoseButton" />
                </div>
                <div style="text-align: right;">
                </div>
                <div>
                    <label class="forItemLabel">
                        &nbsp;Medicine :</label>
                    <asp:TextBox ID="txtMedicine" runat="server" Width="240px" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="reqMedicine" ErrorMessage="Enter Medicine Name" runat="server"
                        ValidationGroup="SaveNM" ControlToValidate="txtMedicine"></asp:RequiredFieldValidator>
                    <br />
                    <br />
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnSaveNM" runat="server" Text="Save" CssClass="ItDoseButton" Width="75px"
                    OnClick="btnSaveNM_Click" ValidationGroup="SaveNM" />&nbsp;
                <asp:Button ID="btnCancelMed" Text="Cancel" runat="server" CssClass="ItDoseButton"
                    Width="75px" />
                    &nbsp;&nbsp;&nbsp;&nbsp;<asp:Label ID="lblMedicine" runat="server" CssClass="ItDoseLblError"
                        Style="font-weight: normal;" />
                </div>
            </asp:Panel>
            <cc1:ModalPopupExtender ID="mpeNewMed" runat="server" CancelControlID="btnCancelMed"
                DropShadow="true" TargetControlID="btnNM" BackgroundCssClass="filterPupupBackground"
                PopupControlID="pnlMed" PopupDragHandleControlID="dragHandle" />
        </div>
         <script id="tb_PatientMedicineSearch" type="text/html">
    <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="Table1"
    style="width:970px; border-collapse:collapse;">
		<tr id="Tr1">
			<th class="GridViewHeaderStyle" scope="col" style="width:5%;">Select</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;width:5%">itemID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:25%;">Medicine name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10%;">Quantity</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10%;">Dose</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10%;">Time</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10%;">Duration</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20%;">Meal</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:20%;display:none"></th>
		</tr>

        <#
       
        var dataLength=PatientData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];
        
          #>
                    <tr id="<#=objRow.SetID#>|<#=objRow.ItemID#>" >
                        <td class="GridViewLabItemStyle" style="width:5%"><input type="checkbox" id="chkSelect" checked="checked" /></td>
                        <td id="tdItemID" class="GridViewLabItemStyle" style="display:none;width:5%"><#=objRow.ItemID#></td>
                        <td  id="tdItemName" class="GridViewLabItemStyle" style="width:25%"><#=objRow.NAME#></td>
                        <td id="tdSetQuantity" class="GridViewLabItemStyle" style="text-align:center;width:10%"><input  type="text" class="ItDoseTextinputText" id="txtQty1"  value="<#=objRow.quantity#>" style="width:70px" onkeypress="return checkForSecondDecimal(this,event)" /></td>
                        <td id="tdDose" class="GridViewLabItemStyle" style="width:10%"><input  type="text" class="ItDoseTextinputText" id="txtsetDose"   value="<#=objRow.Dose#>"style="width:70px" /></td>
                        <td id="tdTime" class="GridViewLabItemStyle" style="width:10%">
                             <span id="spntime" style="display:none"><#=objRow.times#></span><select id="ddlsetTime" runat="server" onchange="calculatePopupQty()"></select></td>
                        <td id="tdduration" class="GridViewLabItemStyle"style="width:10%">
                             <span id="spnduration" style="display:none"><#=objRow.Duration#></span><select id="ddlSetDuration" runat="server" onchange="calculatePopupQty()"></select></td>
                        <td id="tdfoodType" class="GridViewLabItemStyle"style="width:20%">
                            <select id="ddlFoodType">
                                <option>உணவு பிறகு</option>
                                <option>உணவு முன்</option>
                            </select>
                        </td>
                        <td id="tdMedicineType" class="GridViewLabItemStyle" style="display:none;width:5%"><#=objRow.MedicineType#></td>
                </tr>   

            <#}#>

     </table>    
    </script>
         <script id="tb_lastVisit" type="text/html">
    <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="Table2"
    style="width:970px; border-collapse:collapse;">
		<tr id="Tr2">
			<th class="GridViewHeaderStyle" scope="col" style="width:5%;">Select</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;width:5%">itemID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:15%;">Medicine name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:15%;">Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:25%;display:none;">Dr. Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10%;">Dose</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:10%;">Quantity</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10%;">Time</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10%;">Duration</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:25%;">Meal</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;width:20%;">Meal</th>
		</tr>

        <#
       
        var dataLength=LastVisitsData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {

        objRow = LastVisitsData[j];
        
          #>
                    <tr id="Tr3" >
                        <td class="GridViewLabItemStyle" style="width:5%"><input type="checkbox" id="chkLSelect" checked="checked" /></td>
                        <td id="tdLitemid" class="GridViewLabItemStyle" style="display:none;width:5%"><#=objRow.Medicine_ID#></td>
                        <td  id="tdLItemname" class="GridViewLabItemStyle" style="width:15%"><#=objRow.MedicineName#></td>
                        <td  id="tdLDate" class="GridViewLabItemStyle" style="width:15%"><#=objRow.DATE#></td>
                        <td  id="td1" class="GridViewLabItemStyle" style="width:25%;display:none"><#=objRow.drname#></td>
                        <td id="tdLDose" class="GridViewLabItemStyle" style="width:10%"><input  type="text" class="ItDoseTextinputText" id="txtLDose" style="width:70px" value='<#=objRow.Dose#>' /></td>
                           <td id="tdLOrderQuantity" class="GridViewLabItemStyle" style="width:10%"><input  type="text" class="ItDoseTextinputText" id="txtLOrderQuantity" style="width:70px" value='<#=objRow.OrderQuantity#>' onkeypress="return checkForSecondDecimal(this,event)" /></td>
                         <td id="tdLTime" class="GridViewLabItemStyle" style="width:10%"><select id="ddlLTime" runat="server" onchange="calculateLPopupQty();"></select><span id="spnLTime" style="display:none" ><#=objRow.NoTimesDay#></span></td>
                        <td id="tdLDuration" class="GridViewLabItemStyle"style="width:10%"><select id="ddlLDuration" runat="server" onchange="calculateLPopupQty();"></select><span id="spnLduration" style="display:none"><#=objRow.NoOfDays#></span></td>
                        <td id="tdLMeal" class="GridViewLabItemStyle"style="width:25%">
                            <select id="ddlLVisitMeal">
                                <option value="உணவு பிறகு">உணவு பிறகு</option>
                                <option value="உணவு முன்">உணவு முன்</option>
                            </select><span id="spnLvisitmeal" style="display:none"><#=objRow.Meal#></span>
                        </td>
                        <td id="tdLMedicineType" class="GridViewLabItemStyle" style="display:none;width:5%"><#=objRow.MedicineType#></td>
                </tr>   

            <#}#>

     </table>    
    </script>
    </form>
      <script id="sc_Deptstock" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tblDeptStock" style="border-collapse:collapse;">
            <tr>
                <th class="GridViewHeaderStyle" scope="col" style="width: 150px;">Dept. Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 20px;">Quantity</th>
            </tr>
            <#
  var dataLength=DeptLedStock.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {
        objRow = DeptLedStock[j];
          #>
                    <tr id="Tr4" >
                     
                        <td class="GridViewLabItemStyle" style="display:none"><#=j+1#></td>
                        <td id="tdDeptName" class="GridViewLabItemStyle" style="width: 150px;"><#=objRow.DeptName#></td>
                        <td id="tdDeptQuantity" class="GridViewLabItemStyle"><#=objRow.Quantity#></td>
                </tr>
            <#}#>
     </table>    
    </script>
    <script type="text/javascript">
        function BindDropdown() {
            $('#Table1 tr').each(function () {
                if ($(this).attr("id") != "Tr1") {
                    if ($(this).find('#spntime').html() != "") {
                        $(this).find('#ddlsetTime').val($(this).find('#spntime').html())
                    }
                    if ($(this).find('#spnduration').html() != "") {
                        $(this).find('#ddlSetDuration').val($(this).find('#spnduration').html());
                    }
                }
            });
        }
        function calculatePopupQty() {
            $('#Table1 tr').each(function () {
                if ($(this).attr("id") != "Tr1") {
                    var Time = $(this).find('#ddlsetTime').val().split('#')[0];
                    var Duration = $(this).find('#ddlSetDuration').val().split('#')[0];
                    var MedicineType = $(this).find('#tdMedicineType').text();
                    var Quantity;
                    if (MedicineType == "tablet" || MedicineType == "Capsule") {
                        Quantity = Time * Duration;
                        if (Quantity != 0)
                            $(this).find('#txtQty1').val(Quantity);
                        else
                            $(this).find('#txtQty1').val('1');
                    }
                    else
                        $(this).find('#txtQty1').val('1');
                }
            });
        }
        function calculateLPopupQty() {
            $('#Table2 tr').each(function () {
                if ($(this).attr("id") != "Tr2") {
                    var Time = $(this).find('#ddlLTime').val().split('#')[0];
                    var Duration = $(this).find('#ddlLDuration').val().split('#')[0];
                    var MedicineType = $(this).find('#tdLMedicineType').text();
                    var Quantity;
                    if (MedicineType == "tablet" || MedicineType == "Capsule") {
                        Quantity = Time * Duration;
                        if (Quantity != 0)
                            $(this).find('#txtLOrderQuantity').val(Quantity);
                        else
                            $(this).find('#txtLOrderQuantity').val('1');
                    }
                    else
                        $(this).find('#txtQty1').val('1');
                }
            });
        }
        function QuantityCal() {
            var Time = $('#<%=ddlTime.ClientID%>').val();
            var Duration = $('#<%=ddlDays.ClientID%>').val();
            var radios = $.trim($("#<%=rdoType.ClientID%> input[type=radio]:checked").val())
            var MedicineType;
            if (radios == 1)
                MedicineType = $("#<%=lstInv.ClientID %>").val().split('#')[1];
                else
                    MedicineType = $("#<%=lstInv.ClientID %>").val().split('#')[2];
                var Quantity = 0;

                if (MedicineType == "tablet" || MedicineType == "Capsule") {
                    Quantity = Time * Duration;
                    if (Quantity != 0)
                        $('#<%=txtquantity.ClientID%>').val(Quantity);
                else
                    $('#<%=txtquantity.ClientID%>').val('1');
            }
            else {
                $('#<%=txtquantity.ClientID%>').val('1');
            }
        }
        function checkForSecondDecimal(sender, e) {
            var charCode = (e.which) ? e.which : e.keyCode;
            if (charCode != 46 && charCode > 31 && (charCode < 48 || charCode > 57)) {
                $("#lblMsg").text('Enter Numeric Value Only');
                return false;
            }
            else {
                $("#lblMsg").text(' ');
            }
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                                ((e.keyCode) ? e.keyCode :
                                ((e.which) ? e.which : 0));
                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            $("#spnMsg").text('Enter Numeric Value Only');
                        return false;
                    }
                }
            }
            else {
                $("#spnMsg").text(' ');
            }
        }
    </script>
</body>
</html>
