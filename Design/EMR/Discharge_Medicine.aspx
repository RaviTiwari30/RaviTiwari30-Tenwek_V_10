<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Discharge_Medicine.aspx.cs" Inherits="Design_EMR_Discharge_Medicine" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../Styles/CustomStyle.css" rel="stylesheet" />
     <link href="../../Styles/framestyle.css" rel="stylesheet" />
    <link href="../../Styles/grid24.css" rel="stylesheet" />
    <script  type="text/javascript" src="../../Scripts/Message.js"></script>
   <script  src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
        <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>

      <script  type="text/javascript">
          function checkformultiplecheckbox(sender) {
              var chkList = sender.parentNode.parentNode.parentNode;
              var chks = chkList.getElementsByTagName("input");
              for (var i = 0; i < chks.length; i++) {
                  if (chks[i] != sender && sender.checked) {
                      chks[i].checked = false;
                  }
              }

          }
          function validatespace() {
              var Medicine = $('#<%=txtmedicine.ClientID %>').val();
              var Route = $('#<%=ddlRoute.ClientID %>').val();
              var Remarks = $('#<%=txtRemarks.ClientID %>').val();
              if (Medicine.charAt(0) == ' ' || Medicine.charAt(0) == '.' || Medicine.charAt(0) == ',') {
                  $('#<%=txtmedicine.ClientID %>').val('');
                  $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                  Medicine.replace(Medicine.charAt(0), "");
                  return false;
              }
              if (Route.charAt(0) == ' ' || Route.charAt(0) == '.' || Route.charAt(0) == ',') {
                  $('#<%=ddlRoute.ClientID %>').val('');
                  $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                  Route.replace(Route.charAt(0), "");
                  return false;
              }
              if (Remarks.charAt(0) == ' ' || Remarks.charAt(0) == '.' || Remarks.charAt(0) == ',') {
                  $('#<%=txtRemarks.ClientID %>').val('');
                  $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                  Remarks.replace(Remarks.charAt(0), "");
                  return false;
              }
              else {
                  // $('#<%=lblMsg.ClientID %>').text('');
                  return true;
              }

          }
          function check(e) {
              var keynum
              var keychar
              var numcheck
              // For Internet Explorer  
              if (window.event) {
                  keynum = e.keyCode
              }
                  // For Netscape/Firefox/Opera  
              else if (e.which) {
                  keynum = e.which
              }
              keychar = String.fromCharCode(keynum)
              var Medicine = $('#<%=txtmedicine.ClientID %>').val();
              var Route = $('#<%=ddlRoute.ClientID %>').val();
              var Remarks = $('#<%=txtRemarks.ClientID %>').val();
              if (Medicine.charAt(0) == ' ') {
                  $('#<%=txtmedicine.ClientID %>').val('');
                  $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space');
                  return false;
              }
              if (Route.charAt(0) == ' ') {
                  $('#<%=ddlRoute.ClientID %>').val('');
                  $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space');
                  return false;
              }
              if (Remarks.charAt(0) == ' ') {
                  $('#<%=txtRemarks.ClientID %>').val('');
                  $('#<%=lblMsg.ClientID %>').text('First Character Cannot Be Space');
                  return false;
              }
              //List of special characters you want to restrict
              if (keychar == "'" || keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || (keynum >= "40" && keynum <= "45") || (keynum >= "91" && keynum <= "95") || (keynum >= "49" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                  return false;
              }

              else {
                  return true;
              }
          }







</script>
       <script type="text/javascript">

           function searchEMRMedicine() {
               var con = 0;
               var radios = $('input:radio[name=rdoListType]:checked').val();
               if (radios != 4 && radios != 5) {
                   if ($.trim($('#<%=txtmedicine.ClientID %>').val()) == "") {
                       $('#<%=lblMsg.ClientID %>').text('Please Enter Medicine Name');
                       $('#<%=txtmedicine.ClientID %>').focus();
                       con = 1;
                       return false;
                   }
               }
               else if (radios == 4 || radios == 5) {
                   if ($.trim($('#<%=ddlHospitalMedicine.ClientID %>').val()) == "") {
                       $('#<%=lblMsg.ClientID %>').text('Please Select Medicine Name');
                       $('#<%=txtmedicine.ClientID %>').focus();
                       con = 1;
                       return false;
                   }
                   else if ($('#<%=ddlnxtdose.ClientID %>').val() == "") {
                       $('#<%=lblMsg.ClientID %>').text('Please Select Time of next Dose');
                       $('#<%=ddlnxtdose.ClientID %>').focus();
                       con = 1;
                       return false;
                   }
                   else if ($('#<%=txtDose.ClientID %>').val() == "") {
                       $('#<%=lblMsg.ClientID %>').text('Please Select Dose');
                       $('#<%=txtDose.ClientID %>').focus();
                       con = 1;
                       return false;
                   }
                   else if ($('#<%=ddlTime.ClientID %>').val() == "") {
                       $('#<%=lblMsg.ClientID %>').text('Please Select Time');
                       $('#<%=ddlTime.ClientID %>').focus();
                       con = 1;
                       return false;
                   }
                   else if ($('#<%=ddlDays.ClientID %>').val() == "") {
                       $('#<%=lblMsg.ClientID %>').text('Please Select Duration');
                       $('#<%=ddlDays.ClientID %>').focus();
                       con = 1;
                       return false;
                   }

                   //if (!$('input:radio[name=Chkscript]:checked').val()) {
                   //    $('#<%=lblMsg.ClientID %>').text('Please Select Script');
                   //    con = 1;
                   //    return false;
                   // }

               }
               if (con == "0") {
                   $('#<%=lblMsg.ClientID %>').text('');
                   var radio = $.trim($("#<%=rdoListType.ClientID%> input[type=radio]:checked").val())
                   var Medicine;
                   if (radio != 4 && radio != 5)
                       Medicine = $.trim($("#<%=txtmedicine.ClientID%>").val());
                   else
                       Medicine = $.trim($("#<%=ddlHospitalMedicine.ClientID%>").val());
                   $.ajax({
                       type: "POST",
                       url: "Services/EMR.asmx/EMRMedicine",
                       data: '{TID:"' + TID + '",Header:"' + $.trim($("#<%=rdoListType.ClientID%> input[type=radio]:checked").next().text()) + '",Medicine:"' + Medicine + '",Route:"' + $.trim($("#<%=ddlRoute.ClientID%>").val()) + '",Timefornxtdose:"' + $.trim($("#<%=ddlnxtdose.ClientID%>").val().split('#')[0]) + '",Dose:"' + $.trim($("#<%=txtDose.ClientID%>").val().split('#')[0]) + '",Time:"' + $.trim($("#<%=ddlTime.ClientID%>").find("option:selected").text()) + '",Days:"' + $.trim($("#<%=ddlDays.ClientID%>").val().split('#')[0]) + '",Script:"' + $.trim($("#<%=Chkscript.ClientID%> input[type=radio]:checked").val()) + '",Reason:"' + $.trim($("#<%=txtRemarks.ClientID%>").val()) + '",ID:"' + $('#spnmedID').text() + '",Meal:"' + $('#ddlMeal').val() + '"}',
                       dataType: "json",
                       contentType: "application/json;charset=UTF-8",
                       async: true,
                       success: function (response) {
                           EMRMed = (response.d);
                           if (EMRMed == "1") {
                               $("input[type=text]").val('');
                               $('select').prop('selectedIndex', 0);
                               bindEMRMedicine();
                           }
                           else {
                               bindEMRMedicine();
                           }
                       },
                       error: function (xhr, status) {
                           window.status = status + "\r\n" + xhr.responseText;
                       }
                   });
               }
           }
           var TID = "";
           $(document).ready(function () {
               TID = '<%=ViewState["TransID"].ToString()%>';

               bindEMRMedicine();
           });
           function bindEMRMedicine() {
               $.ajax({
                   type: "POST",
                   url: "Services/EMR.asmx/bindEMRMedicine",
                   data: '{TID:"' + TID + '"}',
                   dataType: "json",
                   contentType: "application/json;charset=UTF-8",
                   async: true,
                   success: function (response) {
                       EMRMed = jQuery.parseJSON(response.d);
                       if (EMRMed != null) {
                           var output = $('#tb_EMRSearch').parseTemplate(EMRMed);
                           $('#EMRMedOutput').html(output);
                           $('#EMRMedOutput').show();
                       }
                       else {
                           $('#EMRMedOutput').hide();
                       }
                   },
                   error: function (xhr, status) {
                       window.status = status + "\r\n" + xhr.responseText;
                   }
               });
           }

           function deleteMedicine(rowid) {
               var Id = $(rowid).closest('tr').find('#tdID').text();

               var medicineName = $(rowid).closest('tr').find('#tdMedicine').text();
               $.ajax({
                   type: "POST",
                   url: "Services/EMR.asmx/deleteEMRMedicine",
                   data: '{TID:"' + TID + '",medicineName:"' + medicineName + '",Id:"' + Id + '"}',
                   dataType: "json",
                   contentType: "application/json;charset=UTF-8",
                   async: true,
                   success: function (response) {
                       MedDel = (response.d);
                       if (MedDel == "1") {
                           $("#<%=lblMsg.ClientID%>").text('Item Removed Successfully');
                           bindEMRMedicine();
                       }
                       else {
                           bindEMRMedicine();
                       }
                   },
                   error: function (xhr, status) {
                       window.status = status + "\r\n" + xhr.responseText;
                   }
               });
           }
       </script>
</head>
<body>
    <form id="form1" runat="server">
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" >
          <div class="content" style="text-align: center;">
                <b>Medication Discharge Instructions </b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
        </div>
        <div class="POuter_Box_Inventory">
             <div class="col-md-24">
                      <div class="row">
                            <asp:RadioButtonList ID="rdoListType" runat="server" RepeatDirection="Vertical"
                            CssClass="ItDoseRadiobuttonlist"    RepeatColumns="3"  ClientIDMode="Static"
                                ToolTip="Select List Type"  >
                            <asp:ListItem Text="New Medications To Start Taking At Home" Value="2" Selected="True" />
                            <asp:ListItem Text="Drugs Given In Hospital" Value="4" /> 
                            </asp:RadioButtonList>
                      </div>
                 </div>
        </div>
        <div class="POuter_Box_Inventory">
                <div class="col-md-24">
                      <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                 Medicine Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtmedicine"  runat="server" autocomplete="off"  ClientIDMode="Static" CssClass="ItDoseTextinputText requiredField"
                            onkeyup="validatespace();" TabIndex="1" 
                            ToolTip="Enter Medicine Name"></asp:TextBox>
                               <asp:DropDownList ID="ddlHospitalMedicine" runat="server" style="display:none" ClientIDMode="Static" ></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Route
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:DropDownList ID="ddlRoute" runat="server" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Time of Next<br /> Dose
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:DropDownList ID="ddlnxtdose" CssClass="requiredField" runat="server"  ToolTip="Select Next Dose Time" ClientIDMode="Static"
                            TabIndex="3" ></asp:DropDownList>
                        </div>
                    </div>
                      <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Dose
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:TextBox ID="txtDose" runat="server" CssClass="requiredField" ClientIDMode="Static"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Times
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlTime" runat="server" TabIndex="5" ClientIDMode="Static"
                              ToolTip="Select Time">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Duration
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDays"  CssClass="requiredField" runat="server" ToolTip="Select Days" ClientIDMode="Static"
                            TabIndex="6">
                        </asp:DropDownList>
                        </div>
                    </div>
                      <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Meal
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:RadioButtonList ID="Chkscript" runat="server" RepeatDirection="Horizontal" TabIndex="7" Visible="false">
                <asp:ListItem Selected="True" Text="Yes" Value="Yes"></asp:ListItem>
                <asp:ListItem Text="No" Value="No"></asp:ListItem>
            </asp:RadioButtonList>
            <select id="ddlMeal" >
                <option value="0"></option>
                <option value="BeforeMeal">Before Meal</option>
                <option value="AfterMeal">After Meal</option>
            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Remark
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtRemarks" runat="server" TabIndex="8" MaxLength="100" ClientIDMode="Static"
                            ToolTip="Enter Remarks" />
                        </div>
                            <div class="col-md-2"></div>
                        <div class="col-md-3">
                            <input type="button" value="Add" tabindex="9" onclick="searchEMRMedicine()" class="ItDoseButton" />   <span id="spnmedID" style="display:none"></span>
                        </div>
                      
                    </div>
                </div>
            </div>
    </div>
    <asp:Panel ID="hide" runat="server" Visible="false">
        
           
            <asp:Label ID="lblHeaderBlank" runat="server" Visible="false" ></asp:Label>
            <asp:Button ID="btnSave" runat="server" Text="save" CssClass="ItDoseButton"
                     Visible="False" TabIndex="7" ToolTip="Click To Save" 
                      />

   </asp:Panel>

        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Medicines</div>
        <table  style="width: 100%;border-collapse:collapse" id="myTable">
                <tr >
                    <td colspan="4">
                         <div id="EMRMedOutput" style="max-height: 600px; overflow-x: auto; ">
                        </div>
                        <br />                       
                    </td>
                </tr>
            </table>
    </div>



    </div>
   
           <cc1:AutoCompleteExtender runat="server" ID="autoComplete1" TargetControlID="txtmedicine"
        FirstRowSelected="true" BehaviorID="AutoCompleteEx" ServicePath="~/Design/common/CommonService.asmx"
        ServiceMethod="GetCompletion" MinimumPrefixLength="2" EnableCaching="true"
        CompletionSetCount="20" CompletionInterval="1000" CompletionListCssClass="autocomplete_completionListElement"
        CompletionListItemCssClass="autocomplete_listItem" ShowOnlyCurrentWordInCompletionListItem="true"
        CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem">
        <Animations>
         
                    <OnShow>
                        <Sequence>
                            <%-- Make the completion list transparent and then show it --%>
                            <OpacityAction Opacity="0" />
                            <HideAction Visible="true" />
                            
                            <%--Cache the original size of the completion list the first time
                                the animation is played and then set it to zero --%>
                            <ScriptAction Script="
                                // Cache the size and setup the initial size
                                var behavior = $find('AutoCompleteEx');
                                if (!behavior._height) {
                                    var target = behavior.get_completionList();
                                    behavior._height = target.offsetHeight - 2;
                                    target.style.height = '0px';
                                }" />
                            
                            <%-- Expand from 0px to the appropriate size while fading in --%>
                            <Parallel Duration=".4">
                                <FadeIn />
                                <Length PropertyKey="height" StartValue="0" EndValueScript="$find('AutoCompleteEx')._height" />
                            </Parallel>
                        </Sequence>
                    </OnShow>
                    <OnHide>
                        <%-- Collapse down to 0px and fade out --%>
                        <Parallel Duration=".4">
                            <FadeOut />
                            <Length PropertyKey="height" StartValueScript="$find('AutoCompleteEx')._height" EndValue="0" />
                        </Parallel>
                    </OnHide>
        </Animations>
    </cc1:AutoCompleteExtender>
    </form>
            <script id="tb_EMRSearch" type="text/html">
    <table  cellspacing="0" rules="all" border="1" id="tb_grdEMR"
    style="border-collapse:collapse;"  class="GridViewStyle">
		<tr id="Header">        
            <th class="GridViewHeaderStyle" scope="col" style="width:220px;">Drug Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Dose</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Route</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">How Often</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Duration</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Time of Next Dose</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:50px;">Meal</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:220px;">Remarks</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:30px;display:none"></th>
              <th class="GridViewHeaderStyle" scope="col" style="width:20px;">Edit</th>		
            <th class="GridViewHeaderStyle" scope="col" style="width:20px;">Remove</th>			        
		</tr>
        <#       
        var dataLength=EMRMed.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {       
        objRow = EMRMed[j];
        #>
                    <tr id="<#=j+1#>">                            
                  
                        <#
if(j>0)
  {
    if(EMRMed[j].Header!=EMRMed[j-1].Header)
    {#>    
                 <td class="GridViewLabItemStyle" id="tdHeader"  colspan="8" style=" font:bold; text-align:center" >
                     <b><#=objRow.Header#></b>
                     </td> 
  
    <#}
    
  }
else
    {#>
    <td class="GridViewLabItemStyle" id="td2" colspan="8"  style="font:bold; text-align:center" > <b><#=objRow.Header#></b></td> 
    <#}
    #>
                    
                         </tr> 
      <tr>
                    <td class="GridViewLabItemStyle" id="tdMedicine"  style="width:220px;" ><#=objRow.Medicine#></td>
                    <td class="GridViewLabItemStyle" id="tdDose" style="width:50px; text-align:center"><#=objRow.Dose#></td>
                    <td class="GridViewLabItemStyle" id="tdRoute" style="width:140px;"><#=objRow.Route#></td>
                    <td class="GridViewLabItemStyle" id="tdtime" style="width:50px; text-align:center"><#=objRow.time#></td>
                    <td class="GridViewLabItemStyle" id="tddays" style="width:60px; text-align:center;"><#=objRow.days#></td>
                    <td class="GridViewLabItemStyle" id="tdTimefornxtdose" style="width:70px; text-align:center"><#=objRow.Timefornxtdose#></td>                     
                    <td class="GridViewLabItemStyle" id="tdMeal" style="width:50px; text-align:center;"><#=objRow.Meal#></td>
                    <td class="GridViewLabItemStyle" id="tdReason"  style="width:220px;" ><#=objRow.Reason#></td> 
                    <td class="GridViewLabItemStyle" id="tdID" style="width:30px;display:none"><#=objRow.ID#></td>
           <td class="GridViewLabItemStyle" id="tdHeader1"  style="display:none">
                     <#=objRow.Header#>
                     </td> 
          <td class="GridViewLabItemStyle" style="width:20px; text-align:center"  >
                     <img alt="Edit" src="../../Images/edit.png" style="border: 0px solid #FFFFFF; text-align:center; cursor:pointer"                                    
                         onclick="EditMedicine(this)" title="Click To Edit" />                                                                             
                    </td> 
                     <td class="GridViewLabItemStyle" style="width:20px; text-align:center"  >
                     <img alt="Remove" src="../../Images/Delete.gif" style="border: 0px solid #FFFFFF; text-align:center; cursor:pointer"                                    
                         onclick="deleteMedicine(this)" title="Click To Remove" />                                                                             
                    </td>                    
                    </tr>           
        <#}       
        #>       
     </table>    
    </script>
    <script type="text/javascript">
        function EditMedicine(rowid) {
            var head = $.trim($(rowid).closest('tr').find('#tdHeader1').text());
            if (head == "Stop Taking These Medications At Home") {
                var value = 1;
                var radio = $("[id*=rdoListType] input[value=" + value + "]");
                radio.attr("checked", "checked");
                ShowHide()
            }
            else if (head == "New Medications To Start Taking At Home") {
                var value = 2;
                var radio = $("[id*=rdoListType] input[value=" + value + "]");
                radio.attr("checked", "checked");
                ShowHide()
            }
            else if (head == "Continue Home Medications") {
                var value = 3;
                var radio = $("[id*=rdoListType] input[value=" + value + "]");
                radio.attr("checked", "checked");
                ShowHide()
            }
            else if (head == "Drugs Given In Hospital") {
                var value = 4;
                var radio = $("[id*=rdoListType] input[value=" + value + "]");
                radio.attr("checked", "checked");
                ShowHide()
            }
            else {
                var value = 5;
                var radio = $("[id*=rdoListType] input[value=" + value + "]");
                radio.attr("checked", "checked");
                ShowHide()
            }

            $('#spnmedID').text($(rowid).closest('tr').find('#tdID').text());
            if (head != "Drugs Given In Hospital" && head != "Other Drugs Given In Hospital") {
                $('#txtmedicine').val($(rowid).closest('tr').find('#tdMedicine').text());
            }
            else {
                $('#ddlHospitalMedicine option:selected').text($(rowid).closest('tr').find('#tdMedicine').text());
            }
            $('#ddlRoute').val($(rowid).closest('tr').find('#tdRoute').text());
            $('#ddlnxtdose').val($(rowid).closest('tr').find('#tdTimefornxtdose').text());
            $('#txtDose').val($(rowid).closest('tr').find('#tdDose').text());
            $('#ddlTime').val($(rowid).closest('tr').find('#tdtime').text());
            $('#ddlDays').val($(rowid).closest('tr').find('#tddays').text());
            $('#ddlMeal').val($(rowid).closest('tr').find('#tdMeal').text());
        }
        $(document).ready(function () { ShowHide(); });
        $(document).ready(function () {
            $('#<%=rdoListType.ClientID %> input').change(function () {
                var radios = $("#<%=rdoListType.ClientID%> input[type=radio]:checked").val();
                if (radios == 1) {
                    $('#<%=txtDose.ClientID %>,#<%=ddlTime.ClientID %>,#<%=ddlDays.ClientID %>,#<%=ddlnxtdose.ClientID %>').attr('disabled', 'disabled');
                    $('#<%=Chkscript.ClientID %>').attr('disabled', true);
                    $('#<%=ddlHospitalMedicine.ClientID %>').hide();
                    $('#<%=txtmedicine.ClientID %>').show();
                    $('#<%=ddlTime.ClientID %>').val('');
                }
                else if (radios == 2 || radios == 3) {
                    $('#<%=txtDose.ClientID %>,#<%=ddlTime.ClientID %>,#<%=ddlDays.ClientID %>,#<%=ddlnxtdose.ClientID %>,#<%=Chkscript.ClientID %>').attr('disabled', false);
                    $('#<%=txtmedicine.ClientID %>').focus();
                    $('#<%=ddlHospitalMedicine.ClientID %>').hide();
                    $('#<%=txtmedicine.ClientID %>').show();

                }
                else {
                    $('#<%=txtmedicine.ClientID %>,#<%=ddlRoute.ClientID %>,#<%=txtRemarks.ClientID %>,#<%=txtDose.ClientID %>,#<%=ddlTime.ClientID %>').val('').removeAttr('disabled');
                    $('#<%=ddlDays.ClientID %>,#<%=ddlnxtdose.ClientID %>').val('').removeAttr('disabled');
                    $('#<%=lblMsg.ClientID %>').text('');
                    $('#<%=ddlHospitalMedicine.ClientID %>').show();
                    $('#<%=txtmedicine.ClientID %>').hide();

                }
            })
        });
    function ShowHide() {
        var radios = $("#<%=rdoListType.ClientID%> input[type=radio]:checked").val();
        if (radios == 1) {
            $('#<%=txtDose.ClientID %>,#<%=ddlTime.ClientID %>,#<%=ddlDays.ClientID %>,#<%=ddlnxtdose.ClientID %>').attr('disabled', 'disabled');
            $('#<%=Chkscript.ClientID %>').attr('disabled', true);
            $('#<%=ddlHospitalMedicine.ClientID %>').hide();
            $('#<%=txtmedicine.ClientID %>').show();
            $('#<%=ddlTime.ClientID %>').val('');
        }
        else if (radios == 2 || radios == 3) {
            $('#<%=txtDose.ClientID %>,#<%=ddlTime.ClientID %>,#<%=ddlDays.ClientID %>,#<%=ddlnxtdose.ClientID %>,#<%=Chkscript.ClientID %>').attr('disabled', false);
            $('#<%=txtmedicine.ClientID %>').focus();
            $('#<%=ddlHospitalMedicine.ClientID %>').hide();
            $('#<%=txtmedicine.ClientID %>').show();
            $('#<%=ddlTime.ClientID %>').val('1-0-1');
        }
        else {
            $('#<%=txtmedicine.ClientID %>,#<%=ddlRoute.ClientID %>,#<%=txtRemarks.ClientID %>,#<%=txtDose.ClientID %>,#<%=ddlTime.ClientID %>').val('').removeAttr('disabled');
            $('#<%=ddlDays.ClientID %>,#<%=ddlnxtdose.ClientID %>').val('').removeAttr('disabled');
            $('#<%=lblMsg.ClientID %>').text('');
            $('#<%=ddlHospitalMedicine.ClientID %>').show();
            $('#<%=txtmedicine.ClientID %>').hide();
            $('#<%=ddlTime.ClientID %>').val('1-0-1');
        }
}
    </script>
</body>
</html>
