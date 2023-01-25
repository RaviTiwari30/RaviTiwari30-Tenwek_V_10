<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PatientDietRequest.aspx.cs" Inherits="Design_Kitchen_PatientDietRequest" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
     <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" EnablePageMethods="true" runat="server"
            EnableScriptGlobalization="true" EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Patient Diet Request</b>
                <br />
                <asp:Label ID="lblMsg" CssClass="ItDoseLblError" runat="server" ClientIDMode="Static" style="display:none;"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
             <div class="row">
                 <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtDate" onchange="CheckDate();" runat="server" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="calDate" runat="server" TargetControlID="txtDate" Format="dd-MMM-yyyy">
                        </cc1:CalendarExtender>
                        </div>
                          <div class="col-md-3">
                            <label class="pull-left">
                                Floor
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:DropDownList ID="ddlFloor"   ClientIDMode="Static" runat="server">
                            </asp:DropDownList>
                        </div>
                            <div class="col-md-3">
                            <label class="pull-left">
                                Ward
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlWard"  CssClass="requiredField"  ClientIDMode="Static" runat="server">
                           </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Diet Timing
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:DropDownList ID="ddlDietTiming" CssClass="requiredField" ClientIDMode="Static" runat="server" onchange="hideTable()">
                             </asp:DropDownList>
                            
                        </div>
                        
                        <div class="col-md-3">
                            <label class="pull-left">
                                Diet Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="radio" name="rblIsPrivate1[]" value="0" />Normal
                            <input type="radio" name="rblIsPrivate1[]" value="1" />Private
                            <input type="radio" name="rblIsPrivate1[]" value="2" checked="checked" />Both
                           
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-11">
                        </div>
                        <div class="col-md-3">
                             <input type="button" id="btnSearch" runat="server" class="ItDoseButton" value="Search"  onclick="searchDiet()"/>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                </div>
                 <div class="col-md-1"></div>
            </div>
             </div>
                    <div class="POuter_Box_Inventory">
                           <div class="row">
                <div class="col-md-24">
                    <div class="row">
                          <div class="col-md-2"></div>
                          <div class="col-md-4">
                               <button type="button" style="width:26px;height:25px;margin-left:5px;float:left;background-color: lightcyan;"  class="circle"></button>
                              <b style="margin-top:5px;margin-left:5px;float:left">Fixed</b> 
                        </div>
                         <div class="col-md-4">
                               <button type="button" style="width:26px;height:25px;margin-left:5px;float:left;background-color: Pink;"  class="circle"></button>
                              <b style="margin-top:5px;margin-left:5px;float:left">Pending</b> 
                        </div>
                         <div class="col-md-4">
                               <button type="button" style="width:26px;height:25px;margin-left:5px;float:left;background-color: lemonchiffon;"  class="circle"></button>
                              <b style="margin-top:5px;margin-left:5px;float:left">Freezed</b> 
                        </div>
                         <div class="col-md-4">
                               <button type="button" style="width:26px;height:25px;margin-left:5px;float:left;background-color: yellowgreen;"  class="circle"></button>
                              <b style="margin-top:5px;margin-left:5px;float:left">Issued</b> 
                        </div>
                        <div class="col-md-4">
                               <button type="button" style="width:26px;height:25px;margin-left:5px;float:left;background-color: lightseagreen;"  class="circle"></button>
                              <b style="margin-top:5px;margin-left:5px;float:left">Received</b> 
                        </div>                       
                    </div>
                </div>
            </div>
        </div>
             <div class="POuter_Box_Inventory">
              <table  style="width: 100%; border-collapse:collapse">
                <tr >
                    <td colspan="4">
                        <div id="dietSearchOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>
                        <br />
                    </td>
                </tr>
            </table>
        </div>
         
             <div class="POuter_Box_Inventory" >
              <table  style="width: 100%; border-collapse:collapse">
                <tr >
                    <td colspan="4">
                        <div id="DivAddComponent" style="max-height: 500px; overflow-x: auto;display:none;">
                            <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Select Component</div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="radio" name="rblIsPrivate[]" value="0" />Normal
                            <input type="radio" name="rblIsPrivate[]" value="1" />Private
                           
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Diet Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDietType1" runat="server" TabIndex="2" AutoPostBack="false" onchange="bindSubDietType1($(this).val());"
                                ToolTip="Select Diet Type">
                            </asp:DropDownList>
                        </div>
                         <div class="col-md-3">
                             <label class="pull-left">
                                 Sub Diet Type
                             </label>
                             <b class="pull-right">:</b>
                         </div>
                         <div class="col-md-5">
                             <asp:DropDownList ID="ddlSubDietType1" runat="server" TabIndex="2" AutoPostBack="false"
                                 ToolTip="Select Sub Diet Type">
                             </asp:DropDownList>
                         </div>                        
                    </div> 
                
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Menu
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlMenu1" runat="server" TabIndex="2" AutoPostBack="false"
                                ToolTip="Select Menu">
                            </asp:DropDownList>
                        </div>

                        <div class="col-md-5">
                           </div>
                    
                </div>
            </div>                  
                
            </div>           
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center;">           
            
                             <input type="button" id="btnSave" runat="server" class="ItDoseButton" value="Save"  onclick="viewComponent();"/>        
        </div>

                        </div>
                        <br />
                    </td>
                </tr>
            </table>
        </div>
       
         
         <script type="text/javascript" >
             $(document).ready(function () {
                 $("input[name='rblIsPrivate[]']").change(function () {
                     bindDietType1($("input[name='rblIsPrivate[]']:checked").val());
                 });
                 bindMenu1();
             });
             function enableDiv() {
                 if ($('.Check:checked').length > 0) {
                     $("#DivAddComponent").show();
                 }
                 else {
                     $("#DivAddComponent").hide();
                 }
             }
             function dietComponentDetail1() {
                 var dataComDt = new Array();
                 var ObjComDt = new Object();
                 $("#tbl_DietComponent tr").each(function () {
                     var id = $(this).closest("tr").attr("id");
                     $rowid = $(this).closest('tr');
                     if (id != "Tr1") {
                         if ($(this).find("#chkSelect").is(":checked")) {
                             ObjComDt.TransactionID = $.trim($rowid.find("#tdTransactionID").text());
                             ObjComDt.IPDCaseTypeID = $.trim($rowid.find("#tdIPDCaseTypeID").text());
                             ObjComDt.ItemID = $.trim($rowid.find("#tdItemID").text());
                             ObjComDt.RoomID = $.trim($rowid.find("#tdRoom_ID").text());
                             ObjComDt.SubDietID = $.trim($rowid.find("#tdSubDiet").text());
                             ObjComDt.DietMenuID = $.trim($rowid.find("#tdDietMenuID").text());
                             ObjComDt.DietTimeID = $.trim($rowid.find("#tdDietTimeID").text());
                             ObjComDt.DietID = $.trim($rowid.find("#tdDietID").text());
                             ObjComDt.RequestDate = $.trim($("#txtDate").val());
                             ObjComDt.IsFreeze = $.trim($rowid.find("#tdIsFreezeDiet").text());
                             ObjComDt.ComponentID = $.trim($rowid.find("#tdComponentID").text());
                             ObjComDt.PatientID = $.trim($rowid.find("#tdPID").text());
                             ObjComDt.Rate = $.trim($rowid.find("#tdRate").text());
                             ObjComDt.Quantity = $.trim($rowid.find("#txtQuantity").val());
                             ObjComDt.rateListID = $.trim($rowid.find("#tdRateListID").text());
                             ObjComDt.ComponentName = $.trim($rowid.find("#tdComponentName").text());
                             ObjComDt.patientRequestedID = Number($.trim($rowid.find("#tdpatientRequestedID").text()));
                             dataComDt.push(ObjComDt);
                             ObjComDt = new Object();
                         }
                     }
                 });
                 return dataComDt;
             }
             function toggleCheckAll()
             {
                 if ($("#chkSelectAll").prop('checked') === true) {
                     $(".Check").prop('checked', true);
                 }
                 else {
                     $(".Check").prop('checked', false);
                 }
                 if ($('.Check:checked').length > 0) {
                     $("#DivAddComponent").show();
                 }
                 else {
                     $("#DivAddComponent").hide();
                 }
               
             }
             function viewComponent1(rowID) {
                 $('#pnlDietComponent').show();
                 var dietTimeID = $('#<%=ddlDietTiming.ClientID %>').val();
            var subDietID = $(rowID).closest('tr').find("#tdSubDietID").text();
            var dietMenuID = $(rowID).closest('tr').find("#tdDietMenu_ID").text();
            var IPDCaseTypeID = $(rowID).closest('tr').find("#tdIPDCaseTypeID").text();
            var panelID = $(rowID).closest('tr').find("#tdPanelID").text();
            var TID = $(rowID).closest('tr').find("#tdTransactionID").text();
            var Room_ID = $(rowID).closest('tr').find("#tdRoomID").text();
            var IsFreeze = $(rowID).closest('tr').find("#tdIsFreeze").text();
            var PatientID = $(rowID).closest('tr').find("#tdPatientID").text();
            var IsIssued = $(rowID).closest('tr').find("#tdIsIssued").text();
            var OrderTime = $(rowID).closest('tr').find("#tdOrderTime").text();
            var RequestDate = $('#<%=txtDate.ClientID%>').val();
                //if (subDietID == '0' || dietMenuID == '0') {
                //    modelAlert("Please Select SubDiet and Menu");
                //    return;
                //}
                $.ajax({
                    url: "PatientDietRequest.aspx/getComponent",
                    data: JSON.stringify({ dietTimeID: dietTimeID, subDietID: subDietID, menuID: dietMenuID, IPDCaseTypeID: IPDCaseTypeID, panelID: panelID, TID: TID, Room_ID: Room_ID, IsFreeze: IsFreeze, PatientID: PatientID, RequestDate: RequestDate }),
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        resultCom = jQuery.parseJSON(mydata.d);
                        if (resultCom != null && resultCom.length>0) {
                            var output = $('#tb_dietComponent').parseTemplate(resultCom);
                            $('#divDietComponent').html(output);
                            $('#divDietComponent').show();
                            $('#pnlDietComponent').show();
                            if (IsIssued == "1" || IsFreeze == "1") {
                                $('#btnSaveComponent,.chkAll,.chk').attr('disabled', 'disabled');
                            }

                            else {
                                $('#btnSaveComponent,.chkAll,.chk').removeAttr('disabled');
                            }
                            bindTotalRate();
                            var obj = resultCom[0];
                            if (obj.HideSave == "0") {
                                $('#btnSaveComponent').hide();
                            }
                        }
                        else {
                            $('#divDietComponent').html();
                            $('#divDietComponent').hide();
                            $('pnlDietComponent').hide();

                        }
                    },
                    error: function (error) {
                        alert('Error: ', jQuery.parseJSON(error.d));
                    }
                });

            }

             function hideTable() {
                 $("#DivAddComponent").hide();
                 $("#lblMsg").text('');

                 $('#dietSearchOutput').hide();
                 $('#tbl_DietSearch tr').remove();
             }

             function searchDiet() {
                 $('#btnSearch').attr('disabled', 'disabled').val("Searching...");

                 $("#lblMsg").text('');
                 if ($("#ddlDietTiming").val() == "0") {
                     $("#lblMsg").text('Please Select Diet Timing');
                     modelAlert('Please Select Diet Timing');
                     $("#ddlDietTiming").focus();
                     $('#dietSearchOutput').hide();
                     $('#tbl_DietSearch tr').remove();
                     $('#btnSearch').attr('disabled', false).val("Search");

                     return;
                 }
                 if ($("#<%=ddlWard.ClientID %>").val() == "0")
                 {
                     modelAlert('Please Select Ward');
                     return;
                 }

                 $.ajax({
                     url: "PatientDietRequest.aspx/dietSearch",
                     data: '{IPDCaseTypeID:"' + $("#ddlWard").val() + '",dietTiming:"' + $("#ddlDietTiming").val() + '",dietDate:"' + $("#txtDate").val() + '",floor:"' + $("#ddlFloor").val() + '",isPrivate:"' + $("input[name='rblIsPrivate1[]']:checked").val() + '"}',
                     type: "POST",
                     contentType: "application/json; charset=utf-8",
                     timeout: 120000,
                     async: false,
                     dataType: "json",
                     success: function (result) {
                         dietData = jQuery.parseJSON(result.d);
                         if (dietData != null) {
                             var output = $('#tb_dietSearch').parseTemplate(dietData);
                             $('#dietSearchOutput').html(output);
                             $('#dietSearchOutput').show();
                             if (dietData[0].OrderTime != "") {
                                 //  $("#lblMsg").text('Order Time has Passed Out. Now You Can Only View the Diet Request');
                             }

                             bindDietType();
                             $('#tbl_DietSearch tr:not(#Header)').each(function () {
                                 var dietID = $(this).closest('tr').find('#tdDiet_ID').text().trim();
                                 var FixID = $(this).closest('tr').find('#tdFixID').text().trim();

                                 if (dietID != null && dietID != "") {
                                     $(this).closest('tr').find('#ddlDietType').val(dietID).attr("selected", "selected");

                                     bindSubDietType($(this).closest('tr').find('#ddlDietType').val(), $(this).closest('tr').find("#ddlSubDietType"));

                                     var SubDietID = $(this).closest('tr').find('#tdSubDietID').text().trim();

                                     if (SubDietID != null && SubDietID != "") {
                                         $(this).find('#ddlSubDietType').val(SubDietID).attr("selected", "selected");
                                         bindMenuType($(this).closest('tr').find('#ddlDietType').val(), $(this).closest('tr').find("#ddlSubDietType").val(), $(this).closest('tr').find("#ddlMenu"));
                                     }

                                     var DietMenuID = $(this).closest('tr').find('#tdDietMenu_ID').text().trim();
                                     if (DietMenuID != null && DietMenuID != "") {
                                         $(this).find('#ddlMenu').val(DietMenuID).attr("selected", "selected");
                                         $(this).closest('tr').find("#imgComponent").show();

                                     }
                                 }
                             });
                         }
                         else {
                             $('#dietSearchOutput').html();
                             $('#dietSearchOutput').hide();
                         }
                         $('#btnSearch').attr('disabled', false).val("Search");

                     },
                     error: function (xhr, status) {
                         $('#btnSearch').attr('disabled', false).val("Search");

                     }
                 });
             }
             function CheckDate() {
                 var d = new Date();
                 var GetMonths = new Array(12);
                 GetMonths[0] = "Jan";
                 GetMonths[1] = "Feb";
                 GetMonths[2] = "Mar";
                 GetMonths[3] = "Apr";
                 GetMonths[4] = "May";
                 GetMonths[5] = "Jun";
                 GetMonths[6] = "Jul";
                 GetMonths[7] = "Aug";
                 GetMonths[8] = "Sep";
                 GetMonths[9] = "Oct";
                 GetMonths[10] = "Nov";
                 GetMonths[11] = "Dec";
                 var month = d.getMonth() + 1;
                 var day = d.getDate();
                 var output = (day < 10 ? '0' : '') + day + '-' + GetMonths[month] + '-' + d.getFullYear();
                 var textboxDate = $('#<%=txtDate.ClientID%>').val();
                 if (output > textboxDate) {
                     $('#btnSave').attr("disabled", true);
                 }
             };
         </script>
         </div>

        <script id="tb_dietSearch" type="text/html">
   <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tbl_DietSearch"
        style="width:100%;border-collapse:collapse;">
            <tr id="Header">
                <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
                 <th class="GridViewHeaderStyle" scope="col" style="width:40px;"><input type="checkbox" id="chkSelectAll" onchange="toggleCheckAll();" /></th>
                 <th class="GridViewHeaderStyle" scope="col" style="width:40px;">IPD No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">UHID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Patient Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Panel Name</th>   
                             <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Ward</th>
                             <th class="GridViewHeaderStyle" scope="col" style="width:100px;">Diet Type</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none;">Diet Type</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none;">Sub Diet</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none;">Menu</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Patient Comp.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none;">IPDCaseTypeID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">PanelID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Patient Rec.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">Attendent Comp.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">Attendent Rec.</th>
            </tr>
            <#
            var dataLength=dietData.length;
        var objRow;
        var status;
        for(var j=0;j<dataLength;j++)
        {
            objRow = dietData[j];
        #>
                    <tr id="<#=j+1#>"
                         <# if(objRow.IsReceived =="1"){#>
                        style="background-color:LightSeaGreen"
                        <#}      #> 
                         <#  if(objRow.IsIssued =="1"){#>
                        style="background-color:YellowGreen"
                        <#}      #>     
                         <#  if(objRow.IsFreeze =="1"){#>
                        style="background-color:LemonChiffon"
                        <#}   #>
                        <# if(objRow.SubDietID !=""){#>
                        style="background-color:Pink"
                         <#}     #>     
                              <# if(objRow.FixID !=""){#>
                        style="background-color:LightCyan"
                        <#}  #> >
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                        
                    <td class="GridViewLabItemStyle">
                       <# if(objRow.IsFreeze!="1"){#>  <input type="checkbox" id="chkSelect1" class="Check" onchange="enableDiv();" />
                         <#} #>
                    </td>
                       
                    <td class="GridViewLabItemStyle" id="tdIPDNo"  style="width:40px;text-align:left" ><#=objRow.IPDNo#></td>

                    <td class="GridViewLabItemStyle" id="tdPatientID"  style="width:80px;text-align:left" ><#=objRow.PatientID#></td>
                    <td class="GridViewLabItemStyle" id="tdPName" style="width:140px;"><#=objRow.PName#></td>
                        <td class="GridViewLabItemStyle" id="tdPanel" style="width:140px;"><#=objRow.Panel#></td>
                        <td class="GridViewLabItemStyle" id="tdWard" style="width:140px;"><#=objRow.Ward#></td>
                        <td class="GridViewLabItemStyle" id="td28" style="width:140px;"><#=objRow.IsPrivate#></td>
                    <td class="GridViewLabItemStyle"  style="width:100px;text-align:center;display:none;">
                        <select id="ddlDietType"
                            <# if(objRow.IsPrivateDiet=="1"){#> class="dietTypeP" <#} else{ #>class="dietTypeN" <# } #>
                               onchange="bindSubDiet(this)" style="width:120px"  
                             <# if(objRow.IsFreeze=="1"){#>disabled="disabled" <#} #>
                            <# if(objRow.FixID !=""){#>disabled="disabled" <#} #>
                            ></select>
                    </td>
                    <td class="GridViewLabItemStyle"  style="width:100px;text-align:center;display:none;">
                         <select id="ddlSubDietType" onchange="bindMenu(this)"  style="width:120px" 
                              <# if(objRow.IsFreeze=="1"){#>disabled="disabled" <#} #>
                              <# if(objRow.FixID !=""){#>disabled="disabled" <#} #>
                             ></select>
                    </td>
                    <td class="GridViewLabItemStyle"  style="width:100px;text-align:center;display:none;">
                         <select id="ddlMenu" onchange="bindComponent(this)" style="width:120px" 
                               <# if(objRow.IsIssued=="1"){#>disabled="disabled" <#} #>
                           
                         </select>
                    </td>
                   
                    <td class="GridViewLabItemStyle"   style="width:40px;text-align:center">
                        
                          <img id="imgComponent" src="../../Images/view.GIF" alt="View" style="cursor: pointer;display:none"
                                onclick="viewComponent1(this);" />
                    </td>
                    <td class="GridViewLabItemStyle" id="tdIPDCaseTypeID" style="width:120px;display:none"><#=objRow.IPDCaseTypeID#></td>
                    <td class="GridViewLabItemStyle" id="tdPanelID" style="width:120px;display:none"><#=objRow.PanelID#></td>
                    <td class="GridViewLabItemStyle" id="tdIsIssued" style="width:120px;display:none"><#=objRow.IsIssued#></td>
                    <td class="GridViewLabItemStyle" id="tdIsReceived" style="width:120px;display:none"><#=objRow.IsReceived#></td>
                    <td class="GridViewLabItemStyle" id="tdRequestID" style="width:120px;display:none"><#=objRow.requestID#></td>
                    <td class="GridViewLabItemStyle" id="tdFixID" style="width:120px;display:none"><#=objRow.FixID#></td>
                    <td class="GridViewLabItemStyle" id="tdIsFreeze" style="width:120px;display:none"><#=objRow.IsFreeze#></td>
                    <td class="GridViewLabItemStyle" id="tdSubDietID" style="width:120px;display:none"><#=objRow.SubDietID#></td>
                    <td class="GridViewLabItemStyle" id="tdTransactionID"  style="width:40px;text-align:left;display:none" ><#=objRow.TransactionID#></td>
                    <td class="GridViewLabItemStyle" id="tdRoomID"  style="width:40px;text-align:left;display:none" ><#=objRow.RoomID#></td>  
                    <td class="GridViewLabItemStyle" id="tdDiet_ID"  style="width:40px;text-align:left;display:none" ><#=objRow.DietID#></td>  
                    <td class="GridViewLabItemStyle" id="tdDietMenu_ID"  style="width:40px;text-align:left;display:none" ><#=objRow.DietMenuID#></td>  
                         <td class="GridViewLabItemStyle" id="tdOrderTime"  style="width:40px;text-align:left;display:none" ><#=objRow.OrderTime#></td> 
                        <td class="GridViewLabItemStyle" id="tdPatientType" style="width:120px;display:none"><#=objRow.Patient_Type#></td>  

                                      <td class="GridViewLabItemStyle"   style="width:40px;text-align:center">
                        <input type="button" class="ItDoseButton" value="Receive" id="btnReceive"  onclick="receivedDiet(this)"                     
                            <# if(objRow.IsReceived=="1"){#>
                                style="display:none"
                            <#} else if(objRow.IsIssued =="1"){#>
                                style="display:block"
                            <#} else {#>
                                style="display:none"
                            <#} #>/>
                    </td>   
                    <td class="GridViewLabItemStyle" style="display:none"
                        <# if(objRow.AttnIsReceived =="1"){#>
                            style="width:40px;text-align:center;background-color:LightSeaGreen"
                        <#}
                        else if(objRow.AttnIsIssued =="1"){#>
                            style="width:40px;text-align:center;background-color:YellowGreen"
                        <#}     
                        else if(objRow.AttnIsFreeze =="1"){#>
                            style="width:40px;text-align:center;background-color:LemonChiffon"
                        <#}
                        else if(objRow.AttnSubDietID != ""){#>
                            style="width:40px;text-align:center;background-color:Pink"
                        <#}
                        else{#>
                            style="width:40px;text-align:center;background-color:#eaf3fd;"
                        <#}#>             
                    >                        
                          <img id="img1" src="../../Images/view.GIF" alt="View" style="cursor: pointer;"
                                onclick="viewComponentAttendent(this);" />
                    </td>
                            
                           <td class="GridViewLabItemStyle" style="display:none"
                        <# if(objRow.AttnIsReceived =="1"){#>
                            style="width:40px;text-align:center;background-color:LightSeaGreen"
                        <#}
                        else if(objRow.AttnIsIssued =="1"){#>
                            style="width:40px;text-align:center;background-color:YellowGreen"
                        <#}     
                        else if(objRow.AttnIsFreeze =="1"){#>
                            style="width:40px;text-align:center;background-color:LemonChiffon"
                        <#}
                        else if(objRow.AttnSubDietID != ""){#>
                            style="width:40px;text-align:center;background-color:Pink"
                        <#}
                        else{#>
                            style="width:40px;text-align:center;background-color:#eaf3fd;"
                        <#}#>  
                    >
                        <input type="button" class="ItDoseButton" value="Receive" id="btnAttnReceive"  onclick="receivedDietAttendent(this)"                     
                        <#if(objRow.AttnIsReceived=="1"){#>style="display:none"<#}else if(objRow.AttnIsIssued =="1"){#>style="display:block"<#}else{#>style="display:none"<#} #>/>
                    </td> 
                                            <td class="GridViewLabItemStyle" id="tdRemarks"  style="width:40px;text-align:left;display:none" ><#=objRow.Remarks#></td>
                    <td class="GridViewLabItemStyle" id="tdAttnRequestID"  style="width:40px;text-align:left;display:none" ><#=objRow.AttnRequestID#></td> 
                    <td class="GridViewLabItemStyle" id="tdAttnDietID"  style="width:40px;text-align:left;display:none" ><#=objRow.AttnDietID#></td>
                    <td class="GridViewLabItemStyle" id="tdAttnSubDietID"  style="width:40px;text-align:left;display:none" ><#=objRow.AttnSubDietID#></td>
                    <td class="GridViewLabItemStyle" id="tdAttnDietMenuID"  style="width:40px;text-align:left;display:none" ><#=objRow.AttnDietMenuID#></td>
                    <td class="GridViewLabItemStyle" id="tdAttnIsFreeze"  style="width:40px;text-align:left;display:none" ><#=objRow.AttnIsFreeze#></td>
                    <td class="GridViewLabItemStyle" id="tdAttnIsIssued"  style="width:40px;text-align:left;display:none" ><#=objRow.AttnIsIssued#></td>
                    <td class="GridViewLabItemStyle" id="tdAttnIsReceived"  style="width:40px;text-align:left;display:none" ><#=objRow.AttnIsReceived#></td>
                    <td class="GridViewLabItemStyle" id="tdAttnOrderTime"  style="width:40px;text-align:left;display:none" ><#=objRow.AttnOrderTime#></td> 
                    <td class="GridViewLabItemStyle" id="tdAttnRemarks"  style="width:40px;text-align:left;display:none" ><#=objRow.AttnRemarks#></td>                                                                                     
                    </tr>
        <#}
        #>     
     </table>
    </script>
    <script type="text/javascript">

        function bindMenu1() {
            $.ajax({
                url: "Services/Diet.asmx/bindMenu1",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    dietType = jQuery.parseJSON(result.d);
                    $("#<%=ddlMenu1.ClientID%>").html('');
                    if (dietType.length == 0) {
                        $("#<%=ddlMenu1.ClientID%>").append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        $("#<%=ddlMenu1.ClientID%>").append($("<option></option>").val(0).html('Select'));
                        for (i = 0; i < dietType.length; i++) {
                            if (dietType[i].IsDefault=='1') {
                                $("#<%=ddlMenu1.ClientID%>").append($("<option selected></option>").val(dietType[i].DietMenuID).html(dietType[i].NAME));
                            }
                            else
                            {
                                $("#<%=ddlMenu1.ClientID%>").append($("<option></option>").val(dietType[i].DietMenuID).html(dietType[i].NAME));
                            }
                        }

                    }
                },
                error: function (xhr, status) {
                }
            });
        }



        function bindSubDietType1(diettype) {
            $.ajax({
                url: "Services/Diet.asmx/bindSubDietType1",
                data: '{DietType:"' + diettype + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    dietType = jQuery.parseJSON(result.d);
                    $("#<%=ddlSubDietType1.ClientID%>").html('');
                    if (dietType.length == 0) {
                        $("#<%=ddlSubDietType1.ClientID%>").append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        $("#<%=ddlSubDietType1.ClientID%>").append($("<option></option>").val(0).html('Select'));
                        for (i = 0; i < dietType.length; i++) {
                            $("#<%=ddlSubDietType1.ClientID%>").append($("<option></option>").val(dietType[i].SubDietID).html(dietType[i].NAME));

                        }
                        if ($("input[name='rblIsPrivate[]']:checked").val() == '1')
                        {
                            $("#<%=ddlSubDietType1.ClientID%>").val(dietType[0].SubDietIDDefaultP);
                        }
                        else
                        {
                            $("#<%=ddlSubDietType1.ClientID%>").val(dietType[0].SubDietIDDefaultN);
                }
                    }
                },
                error: function (xhr, status) {
                }
            });
        }


        function bindDietType1(isprivate) {
            $.ajax({
                url: "Services/Diet.asmx/bindDietType1",
                data: '{IsPrivate:"' + isprivate + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    dietType = jQuery.parseJSON(result.d);
                    $("#<%=ddlDietType1.ClientID%>").html('');
                    
                    if (dietType.length == 0) {
                        $("#<%=ddlDietType1.ClientID%>").append($("<option></option>").val("0").html("---No Data Found---"));
                       }
                    else {
                        $("#<%=ddlDietType1.ClientID%>").append($("<option></option>").val(0).html('Select'));
                        for (i = 0; i < dietType.length; i++) {

                            $("#<%=ddlDietType1.ClientID%>").append($("<option></option>").val(dietType[i].DietID).html(dietType[i].NAME));
                                                       
                        }
                        var def = '';
                        if (isprivate == '1') {
                            $("#<%=ddlDietType1.ClientID%>").val(dietType[0].DietIDDefaultP);
                        }
                        else {

                            $("#<%=ddlDietType1.ClientID%>").val(dietType[0].DietIDDefaultN);
                        }

                        bindSubDietType1($("#<%=ddlDietType1.ClientID%>").val());
                        

                    }
                },
                error: function (xhr, status) {
                }
            });
        }


        function bindDietType() {
            $.ajax({
                url: "Services/Diet.asmx/bindDietType",
                data: '{dietTiming:"' + $("#ddlDietTiming").val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    dietType = jQuery.parseJSON(result.d);
                    if (dietType.length == 0) {
                        $(".dietTypeN").append($("<option></option>").val("0").html("---No Data Found---"));
                        $(".dietTypeP").append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        $(".dietTypeP").append($("<option></option>").val(0).html('Select'));
                        $(".dietTypeN").append($("<option></option>").val(0).html('Select'));
                        for (i = 0; i < dietType.length; i++) {
                            if (dietType[i].IsDefault == '1') {
                                $(".dietTypeP").append($("<option selected></option>").val(dietType[i].DietID).html(dietType[i].DietName));
                            }
                            else
                            {
                                $(".dietTypeP").append($("<option></option>").val(dietType[i].DietID).html(dietType[i].DietName));
                            }
                            if (dietType[i].IsPanelApproved == '1')
                            {
                                if (dietType[i].IsDefault == '1') {
                                    $(".dietTypeN").append($("<option selected></option>").val(dietType[i].DietID).html(dietType[i].DietName));
                                }
                                else {
                                    $(".dietTypeN").append($("<option></option>").val(dietType[i].DietID).html(dietType[i].DietName));
                                }
                            }
                        }

                    }
                },
                error: function (xhr, status) {
                }
            });
        }

        function viewComponentAttendent(rowID) {
            var dietTimeID = $('#<%=ddlDietTiming.ClientID %>').val();
            var subDietID = '<%=Resources.Resource.AttendentSubDietID%>';
            var dietMenuID = '';
            if ($(rowID).closest('tr').find("#ddlSubDietType").val() == '<%=Resources.Resource.AttendentSubDietID%>') {
                dietMenuID = $(rowID).closest('tr').find("#ddlMenu").val();
            }
            var IPDCaseType_ID = $(rowID).closest('tr').find("#tdIPDCaseTypeID").text();

            var panelID = $(rowID).closest('tr').find("#tdPanelID").text();
            var TID = $(rowID).closest('tr').find("#tdTransactionID").text();
            var Room_ID = $(rowID).closest('tr').find("#tdRoomID").text();
            var IsFreeze = $(rowID).closest('tr').find("#tdAttnIsFreeze").text();
            var Patient_ID = $(rowID).closest('tr').find("#tdPatient_ID").text();
            var IsIssued = $(rowID).closest('tr').find("#tdAttnIsIssued").text();
            var OrderTime = $(rowID).closest('tr').find("#tdAttnOrderTime").text();
            var RequestDate = $('#<%=txtDate.ClientID%>').val();
            var patientType = $(rowID).closest('tr').find("#tdPatientType").text();

            $('#spnRequestIDAttn').text($(rowID).closest('tr').find('#tdAttnRequestID').text());
            $('#txtDietRemarksAttn').val($(rowID).closest('tr').find('#tdAttnRemarks').text())
            $('#spnRowIDAttn').text($(rowID).closest('tr').attr('id'));

            $.ajax({
                url: "PatientDietRequest.aspx/getComponentAttendent",
                data: JSON.stringify({ dietTimeID: dietTimeID, subDietID: subDietID, menuID: dietMenuID, IPDCaseType_ID: IPDCaseType_ID, panelID: panelID, TID: TID, Room_ID: Room_ID, IsFreeze: IsFreeze, Patient_ID: Patient_ID, RequestDate: RequestDate, patientType: patientType }),
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    resultCom = jQuery.parseJSON(mydata.d);
                    if (resultCom != null) {
                        var output = $('#tb_dietComponentAttendent').parseTemplate(resultCom);
                        $('#divDietComponentAttendent').html(output);
                        $('#divDietComponentAttendent').show();
                        $('#pnlDietComponentAttendent').show();

                        if (IsIssued == "1" || IsFreeze == "1") {
                            $('#btnSaveComponentAttn,.chkAllAttendent,.chkAttn').attr('disabled', 'disabled');
                        }
                        else {
                            $('#btnSaveComponentAttn,.chkAllAttendent,.chkAttn').removeAttr('disabled');
                        }
                        bindTotalRateAttendent();
                    }
                    else {
                        $('#divDietComponentAttendent').html();
                        $('#divDietComponentAttendent').hide();
                        $('#pnlDietComponentAttendent').hide();
                    }
                },
                error: function (error) {
                    alert('Error: ', jQuery.parseJSON(error.d));
                }
            });
        }

        function receivedDietAttendent(rowID) {
            $(rowID).closest('tr').find("#btnAttnReceive").attr('disabled', true).val("Submitting...");
            var RequestID = $(rowID).closest('tr').find("#tdAttnRequestID").text();
            $.ajax({
                url: "PatientDietRequest.aspx/receivedAttendentDiet",
                data: '{RequestID:"' + RequestID + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: "120000",
                dataType: "json",
                success: function (result) {
                    OutPut = result.d;
                    if (result.d == "1") {
                        DisplayMsg('MM01', 'lblMsg');
                    }
                    else {
                        DisplayMsg('MM05', 'lblMsg');
                    }
                    $(rowID).closest('tr').find("#btnAttnReceive").attr('disabled', true)
                    searchDiet();
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblMsg');
                    $(rowID).closest('tr').find("#btnAttnReceive").attr('disabled', true);
                }
            });
        }

        function bindSubDiet(rowID) {
            var DietID = $(rowID).closest('tr').find("#ddlDietType").val();
            $(rowID).closest('tr').find("#ddlSubDietType option").remove();
            bindSubDietType(DietID, $(rowID).closest('tr').find("#ddlSubDietType"));
        }

        function bindMenu(rowID) {
            var dietID = $(rowID).closest('tr').find("#ddlDietType").val();
            var subDietID = $(rowID).closest('tr').find("#ddlSubDietType").val();
            $(rowID).closest('tr').find("#ddlMenu option").remove();
            bindMenuType(dietID, subDietID, $(rowID).closest('tr').find("#ddlMenu"));
        }

        function bindComponent(rowID) {
            var dietMenuID = $(rowID).closest('tr').find("#ddlDietType").val();
            var subDietID = $(rowID).closest('tr').find("#ddlSubDietType").val();
            // bindComponentType(dietMenuID, subDietID, $(rowID).closest('tr').find("#ddlComponent"));
            $(rowID).closest('tr').find("#imgComponent").show();
        }
        function bindSubDietType(DietID, SubDietType) {
            $.ajax({
                url: "Services/Diet.asmx/bindSubDietType",
                data: '{dietTiming:"' + $("#ddlDietTiming").val() + '",DietID:"' + DietID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    subDietType = jQuery.parseJSON(result.d);
                    if (subDietType.length == 0) {
                        SubDietType.append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        SubDietType.append($("<option></option>").val(0).html('Select'));
                        for (i = 0; i < subDietType.length; i++) {
                            if (subDietType[i].IsDefault == '1') {
                                SubDietType.append($("<option selected></option>").val(subDietType[i].SubDietID).html(subDietType[i].SubDietName));
                            }
                           else {
                                SubDietType.append($("<option></option>").val(subDietType[i].SubDietID).html(subDietType[i].SubDietName));
                            }
                        }

                    }
                },
                error: function (xhr, status) {
                }
            });
        }


        function bindMenuType(dietID, subDietID, menu) {
            $.ajax({
                url: "Services/Diet.asmx/bindMenu",
                data: '{dietTiming:"' + $("#ddlDietTiming").val() + '",dietID:"' + dietID + '",subDietID:"' + subDietID + '" ,date:"' + $("#txtDate").val() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    menuType = jQuery.parseJSON(result.d);
                    if (menuType.length == 0) {
                        menu.append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        menu.append($("<option></option>").val(0).html('Select'));
                        for (i = 0; i < menuType.length; i++) {
                            menu.append($("<option></option>").val(menuType[i].DietMenuID).html(menuType[i].Name));
                        }

                    }
                },
                error: function (xhr, status) {
                }
            });
        }


        function bindComponentType(dietMenuID, subDietID, Component) {
            $.ajax({
                url: "Services/Diet.asmx/bindComponent",
                data: '{dietTiming:"' + $("#ddlDietTiming").val() + '",dietMenuID:"' + dietMenuID + '",subDietID:"' + subDietID + '" }',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: true,
                dataType: "json",
                success: function (result) {
                    componentType = jQuery.parseJSON(result.d);
                    if (componentType.length == 0) {
                        Component.append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {


                        //  Component.append($("<option></option>").val(0).html('Select'));
                        for (i = 0; i < componentType.length; i++) {


                            Component.append($("<option></option>").val(componentType[i].ComponentID).html(componentType[i].ComponentName));
                        }

                    }
                },
                error: function (xhr, status) {
                }
            });
        }

        function viewComponent() {
            $('#pnlDietComponent').show();
            var dietTimeID = $('#<%=ddlDietTiming.ClientID %>').val();
            var subDietID = $("#<%=ddlSubDietType1.ClientID %>").val();
            var dietMenuID = $("#<%=ddlMenu1.ClientID %>").val();
                var IPDCaseTypeID = $('#<%=ddlWard.ClientID %>').val();
                //var panelID = $(rowID).closest('tr').find("#tdPanelID").text();
                //var TID = $(rowID).closest('tr').find("#tdTransactionID").text();
                //var Room_ID = $(rowID).closest('tr').find("#tdRoomID").text();
                //var IsFreeze = $(rowID).closest('tr').find("#tdIsFreeze").text();
                //var PatientID = $(rowID).closest('tr').find("#tdPatientID").text();
                //var IsIssued = $(rowID).closest('tr').find("#tdIsIssued").text();
                //var OrderTime = $(rowID).closest('tr').find("#tdOrderTime").text();
                var RequestDate = $('#<%=txtDate.ClientID%>').val();
            if (subDietID == '0' || dietMenuID == '0') {
                modelAlert("Please Select SubDiet and Menu");
                return;
            }
            $.ajax({
                url: "PatientDietRequest.aspx/getComponent1",
                data: JSON.stringify({ dietTimeID: dietTimeID, subDietID: subDietID, menuID: dietMenuID, IPDCaseTypeID: IPDCaseTypeID, RequestDate: RequestDate }),
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    resultCom = jQuery.parseJSON(mydata.d);
                    if (resultCom != null &&  resultCom.length>0) {
                        var output = $('#tb_dietComponent').parseTemplate(resultCom);
                        $('#divDietComponent').html(output);
                        $('#divDietComponent').show();
                        $('#pnlDietComponent').show();
                        
                        bindTotalRate();
                        var obj=resultCom[0];
                        if (obj.HideSave == "1")
                        {
                            $('#btnSaveComponent').show();

                        }
                    }
                    else {
                        modelAlert('No Component Map with selected Menu')
                        $('#divDietComponent').html();
                        $('#divDietComponent').hide();
                        $('pnlDietComponent').hide();

                    }
                },
                error: function (error) {
                    alert('Error: ', jQuery.parseJSON(error.d));
                }
            });

        }


        function cancelDietComponent() {
            $('pnlDietComponent').hide();
        }
        function closeComponent() {
            $('pnlDietComponent').hide();
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                $('pnlDietComponent').hide();
            }
        }
        function bindRate(rowID) {
            var totalRate = 0;
            var chkCount = 0;
            $("#tbl_DietComponent").find("#chkSelect").each(function () {
                var id = $(this).closest("tr").attr("id");
                $row = $(this).closest('tr');
                if ($row.find('#chkSelect').attr("checked")) {
                    var rate = parseFloat($row.find('#tdRate').text());
                    var Qty = parseFloat($row.find('#txtQuantity').val());
                    if (isNaN(Qty) || Qty == "") {
                        Qty = 1;
                        $row.find('#txtQuantity').val(1);
                    }
                    if (isNaN(rate) || rate == "")
                        rate = 0;
                    chkCount += 1;
                    totalRate += parseFloat(parseFloat(rate) * parseFloat(Qty));
                }
                $("#spnTotalRate").text(totalRate);
            });
            if (chkCount > 0) {
                $("#btnSaveComponent").show();
                $("#btnSaveComponent").removeAttr('disabled');

            }

            else {
                $("#btnSaveComponent").hide();

            }

        }
        function bindTotalRate() {
            var totalRate = 0;
            var chkCount = 0;
            $("#tbl_DietComponent").find("#chkSelect").each(function () {
                var id = $(this).closest("tr").attr("id");
                $row = $(this).closest('tr');
                if ($row.find('#chkSelect').attr("checked")) {
                    var rate = parseFloat($row.find('#tdRate').text());
                    if (isNaN(rate) || rate == "")
                        rate = 0;
                    chkCount += 1;
                    totalRate += parseFloat(rate);
                }
                $("#spnTotalRate").text(totalRate);
            });
            if (chkCount > 0) {
                $("#btnSaveComponent").show();
            }

            else {
                $("#btnSaveComponent").hide();

            }
        }
        function chkAll(rowID) {
            if ($(".chkAll").is(':checked'))
                $(".chk").prop('checked', 'checked');
            else
                $(".chk").prop('checked', false);

            bindTotalRate();
        }

    </script>
     <script id="tb_dietComponent" type="text/html">
   <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tbl_DietComponent"
        style="width:840px;border-collapse:collapse;">
            <tr id="Tr1">
                <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.
                     <input type="checkbox" class ="chkAll"  onclick="chkAll(this)" />
                </th>
                <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Component Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Qty.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none;">Rate</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Type</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Unit</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Calories</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Protein</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Sodium</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">SaturatedFat</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">T_Fat</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Calcium</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Iron</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">zinc</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;display:none">itemID</th>
            </tr>
            <#
            var dataLength=resultCom.length;
        var objRow;
        for(var j=0;j<dataLength;j++)
        {
            objRow = resultCom[j];
        #>
                    <tr id="trComHeader">
                    <td class="GridViewLabItemStyle"><#=j+1#>
                        <input type="checkbox" id="chkSelect"   onclick="bindRate(this)"  class="chk"
                           
                            <# if(objRow.PatComDetail !="0" && objRow.PatComDetail !=""){#>
                        checked="checked"
                        <#} 
                            
                            #>
                             />
                    </td>
                  <td class="GridViewLabItemStyle" id="tdComponentName"  style="width:40px;text-align:left" ><#=objRow.ComponentName#></td>
                  <td class="GridViewLabItemStyle" id="tdQty" style="width:60px;">
                      <input type="text" id="txtQuantity" value="<#=objRow.Qty#>" onkeyup="bindRate(this)"  style="width:30px" onkeypress="return isNumberKey(event)" class="ItDoseTextinputNum" maxlength="4" />
                      </td>
                  <td class="GridViewLabItemStyle" id="tdRate" style="width:120px;display:none;"><#=objRow.Rate#></td>                   
                   
                  <td class="GridViewLabItemStyle" id="tdType"  style="width:40px;text-align:left" ><#=objRow.Type#></td>
                  <td class="GridViewLabItemStyle" id="tdUnit" style="width:120px;"><#=objRow.Unit#></td> 
                  <td class="GridViewLabItemStyle" id="tdCalories"  style="width:40px;text-align:left" ><#=objRow.Calories#></td>
                  <td class="GridViewLabItemStyle" id="tdProtein" style="width:120px;"><#=objRow.Protein#></td>
                  <td class="GridViewLabItemStyle" id="tdSodium"  style="width:40px;text-align:left" ><#=objRow.Sodium#></td>
                  <td class="GridViewLabItemStyle" id="tdSaturatedFat" style="width:120px;"><#=objRow.SaturatedFat#></td> 
                  <td class="GridViewLabItemStyle" id="tdT_Fat"  style="width:40px;text-align:left" ><#=objRow.T_Fat#></td>
                  <td class="GridViewLabItemStyle" id="tdCalcium" style="width:120px;"><#=objRow.Calcium#></td>
                  <td class="GridViewLabItemStyle" id="tdIron"  style="width:40px;text-align:left" ><#=objRow.Iron#></td>
                  <td class="GridViewLabItemStyle" id="tdzinc" style="width:120px;"><#=objRow.zinc#></td> 
                  <td class="GridViewLabItemStyle" id="tdItemID" style="width:120px;display:none"><#=objRow.ItemID#></td> 
                 <td class="GridViewLabItemStyle" id="tdTransactionID" style="width:120px;display:none"><#=objRow.TransactionID#></td> 
                 <td class="GridViewLabItemStyle" id="tdIPDCaseTypeID" style="width:120px;display:none"><#=objRow.IPDCaseTypeID#></td> 
                 <td class="GridViewLabItemStyle" id="tdRoom_ID" style="width:120px;display:none"><#=objRow.Room_ID#></td>
                 <td class="GridViewLabItemStyle" id="tdDietTimeID" style="width:120px;display:none"><#=objRow.dietTimeID#></td> 
                 <td class="GridViewLabItemStyle" id="tdSubDiet" style="width:120px;display:none"><#=objRow.SubDietID#></td> 
                 <td class="GridViewLabItemStyle" id="tdDietMenuID" style="width:120px;display:none"><#=objRow.DietMenuID#></td>
                 <td class="GridViewLabItemStyle" id="tdDietID" style="width:120px;display:none"><#=objRow.DietID#></td>
                 <td class="GridViewLabItemStyle" id="tdIsFreezeDiet" style="width:120px;display:none"><#=objRow.IsFreeze#></td>
                 <td class="GridViewLabItemStyle" id="tdComponentID" style="width:120px;display:none"><#=objRow.ComponentID#></td>
                 <td class="GridViewLabItemStyle" id="tdPID" style="width:120px;display:none"><#=objRow.PatientID#></td>
                 <td class="GridViewLabItemStyle" id="tdRateListID" style="width:120px;display:none"><#=objRow.RateListID#></td>
                 <td class="GridViewLabItemStyle" id="tdPatComDetail" style="width:120px;display:none"><#=objRow.PatComDetail#></td>
                        <td class="GridViewLabItemStyle" id="tdpatientRequestedID" style="width:120px;display:none"><#=objRow.RequestedID#></td>
       
                        
                        
                    </tr>

        <#}

        #>
       
     </table>
    </script>
    <script id="Script1" type="text/html">
   <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tbl_DietComponent1"
        style="width:840px;border-collapse:collapse;">
            <tr id="Tr3">
                <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.
                     <input type="checkbox" class ="chkAll"  onclick="chkAll(this)" />
                </th>
                <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Component Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Qty.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none;">Rate</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Type</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Unit</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Calories</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Protein</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Sodium</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">SaturatedFat</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">T_Fat</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Calcium</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Iron</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">zinc</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;display:none">itemID</th>
            </tr>
            <#
            var dataLength=resultCom.length;
        var objRow;
        for(var j=0;j<dataLength;j++)
        {
            objRow = resultCom[j];
        #>
                    <tr id="tr4">
                    <td class="GridViewLabItemStyle"><#=j+1#>
                        <input type="checkbox" id="Checkbox1"   onclick="bindRate(this)"  class="chk"
                           
                            <# if(objRow.PatComDetail !="0"){#>
                        checked="checked"
                        <#} 
                            
                            #>
                             />
                    </td>
                  <td class="GridViewLabItemStyle" id="td1"  style="width:40px;text-align:left" ><#=objRow.ComponentName#></td>
                  <td class="GridViewLabItemStyle" id="td2" style="width:60px;">
                      <input type="text" id="Text1" value="<#=objRow.Qty#>" onkeyup="bindRate(this)"  style="width:30px" onkeypress="return isNumberKey(event)" class="ItDoseTextinputNum" maxlength="4" />
                      </td>
                  <td class="GridViewLabItemStyle" id="td3" style="width:120px;display:none;"><#=objRow.Rate#></td>                   
                   
                  <td class="GridViewLabItemStyle" id="td4"  style="width:40px;text-align:left" ><#=objRow.Type#></td>
                  <td class="GridViewLabItemStyle" id="td5" style="width:120px;"><#=objRow.Unit#></td> 
                  <td class="GridViewLabItemStyle" id="td6"  style="width:40px;text-align:left" ><#=objRow.Calories#></td>
                  <td class="GridViewLabItemStyle" id="td7" style="width:120px;"><#=objRow.Protein#></td>
                  <td class="GridViewLabItemStyle" id="td8"  style="width:40px;text-align:left" ><#=objRow.Sodium#></td>
                  <td class="GridViewLabItemStyle" id="td9" style="width:120px;"><#=objRow.SaturatedFat#></td> 
                  <td class="GridViewLabItemStyle" id="td10"  style="width:40px;text-align:left" ><#=objRow.T_Fat#></td>
                  <td class="GridViewLabItemStyle" id="td11" style="width:120px;"><#=objRow.Calcium#></td>
                  <td class="GridViewLabItemStyle" id="td12"  style="width:40px;text-align:left" ><#=objRow.Iron#></td>
                  <td class="GridViewLabItemStyle" id="td13" style="width:120px;"><#=objRow.zinc#></td> 
                  <td class="GridViewLabItemStyle" id="td14" style="width:120px;display:none"><#=objRow.ItemID#></td> 
                 <td class="GridViewLabItemStyle" id="td15" style="width:120px;display:none"><#=objRow.TransactionID#></td> 
                 <td class="GridViewLabItemStyle" id="td16" style="width:120px;display:none"><#=objRow.IPDCaseTypeID#></td> 
                 <td class="GridViewLabItemStyle" id="td17" style="width:120px;display:none"><#=objRow.Room_ID#></td>
                 <td class="GridViewLabItemStyle" id="td18" style="width:120px;display:none"><#=objRow.dietTimeID#></td> 
                 <td class="GridViewLabItemStyle" id="td19" style="width:120px;display:none"><#=objRow.SubDietID#></td> 
                 <td class="GridViewLabItemStyle" id="td20" style="width:120px;display:none"><#=objRow.DietMenuID#></td>
                 <td class="GridViewLabItemStyle" id="td21" style="width:120px;display:none"><#=objRow.DietID#></td>
                 <td class="GridViewLabItemStyle" id="td22" style="width:120px;display:none"><#=objRow.IsFreeze#></td>
                 <td class="GridViewLabItemStyle" id="td23" style="width:120px;display:none"><#=objRow.ComponentID#></td>
                 <td class="GridViewLabItemStyle" id="td24" style="width:120px;display:none"><#=objRow.PatientID#></td>
                 <td class="GridViewLabItemStyle" id="td25" style="width:120px;display:none"><#=objRow.RateListID#></td>
                 <td class="GridViewLabItemStyle" id="td26" style="width:120px;display:none"><#=objRow.PatComDetail#></td>
                        <td class="GridViewLabItemStyle" id="td27" style="width:120px;display:none"><#=objRow.RequestedID#></td>
       
                        
                        
                    </tr>

        <#}

        #>
       
     </table>
    </script>
     <script type="text/javascript" >
         function save() {
             var flag = '1';
             if (flag == '1') {
                 saveComponent();
             }
             else {
                 saveComponent1();
             }

         }
         function saveComponent1() {
             $('#btnSaveComponent').attr('disabled', true).val("Submitting...");
             var ComponentDetail = dietComponentDetail1();
             $.ajax({
                 url: "PatientDietRequest.aspx/saveComponent1",
                 data: JSON.stringify({ ComponentDetail: ComponentDetail }),
                 type: "Post",
                 contentType: "application/json; charset=utf-8",
                 timeout: "120000",
                 dataType: "json",
                 success: function (result) {
                     OutPut = result.d;
                     if (result.d == "1") {
                         DisplayMsg('MM01', 'lblMsg');
                         searchDiet();
                     }
                     else {
                         DisplayMsg('MM05', 'lblMsg');
                     }
                     $('#btnSaveComponent').attr('disabled', true).val("Save");
                     $('pnlDietComponent').hide();
                 },
                 error: function (xhr, status) {
                     DisplayMsg('MM05', 'lblMsg');
                     $('#btnSaveComponent').attr('disabled', true).val("Save");
                     $('pnlDietComponent').hide();
                 }
             });

         }

         function saveComponent() {
             $('#btnSaveComponent').attr('disabled', true).val("Submitting...");
             var ComponentDetaillist = dietComponentDetail();
             $.ajax({
                 url: "PatientDietRequest.aspx/saveComponent",
                 data: JSON.stringify({ ComponentDetaillist: ComponentDetaillist }),
                 type: "Post",
                 contentType: "application/json; charset=utf-8",
                 timeout: "120000",
                 dataType: "json",
                 success: function (result) {
                     OutPut = result.d;
                     if (result.d == "1") {
                         modelAlert("Saved Successfully.", function () {
                             searchDiet();
                             $("#divDietComponent").hide();
                             $('#pnlDietComponent').hide();
                             
                         });
                         //DisplayMsg('MM01', 'lblMsg');
                         
                     }
                     else {
                         DisplayMsg('MM05', 'lblMsg');
                     }
                     $('#btnSaveComponent').attr('disabled', true).val("Save");
                     $('#pnlDietComponent').hide();
                 },
                 error: function (xhr, status) {
                     DisplayMsg('MM05', 'lblMsg');
                     $('#btnSaveComponent').attr('disabled', true).val("Save");
                     $('pnlDietComponent').hide();
                 }
             });

         }

         function dietComponentDetail() {

             var dataGridDt = new Array();
             var ObjGridDt = new Object();
             
             $("#tbl_DietSearch tr").each(function () {
                 var id1 = $(this).closest("tr").attr("id");
                 $rowid1 = $(this).closest('tr');
                 if (id1 != "Tr1") {
                     if ($(this).find("#chkSelect1").is(":checked"))
                     {
             var dataComDt = new Array();
             var ObjComDt = new Object();
             $("#tbl_DietComponent tr").each(function () {
                 var id = $(this).closest("tr").attr("id");
                 $rowid = $(this).closest('tr');
                 if (id != "Tr1") {
                     if ($(this).find("#chkSelect").is(":checked")) {
                         ObjComDt.TransactionID = $.trim($rowid1.find("#tdTransactionID").text());
                         ObjComDt.IPDCaseTypeID = $.trim($rowid1.find("#tdIPDCaseTypeID").text());
                         ObjComDt.ItemID = $.trim($rowid.find("#tdItemID").text());
                         ObjComDt.RoomID = $.trim($rowid1.find("#tdRoomID").text());
                         //if ($rowid1.find("#tdSubDietID").text() == "")
                         //{

                         //    ObjComDt.SubDietID = 0;
                         //}
                         //else
                         //{
                             //  ObjComDt.SubDietID = $.trim($rowid1.find("#tdSubDietID").text());
                             ObjComDt.SubDietID = $.trim($("#<%=ddlSubDietType1.ClientID%>").val());
                        // }
                         //if ($rowid1.find("#tdDietMenu_ID").text() == "") {

                         //    ObjComDt.DietMenuID =0;
                         //}
                         //else {
                             ObjComDt.DietMenuID = $.trim($("#<%=ddlMenu1.ClientID%>").val());

                         //}
                         ObjComDt.DietTimeID = $.trim($("#<%=ddlDietTiming.ClientID%>").val());
                         // $.trim($rowid1.find("#tdOrderTime").text());
                         //if ($rowid1.find("#tdDiet_ID").text() == "") {
                         //    ObjComDt.DietID = 0;
                         //}
                         //else
                         //{
                             ObjComDt.DietID = $.trim($("#<%=ddlDietType1.ClientID%>").val());
                         //}
                         ObjComDt.RequestDate = $.trim($("#txtDate").val());
                         ObjComDt.IsFreeze = $.trim($rowid1.find("#tdIsFreeze").text());
                         ObjComDt.ComponentID = $.trim($rowid.find("#tdComponentID").text());
                         ObjComDt.PatientID = $.trim($rowid1.find("#tdPatientID").text());
                         ObjComDt.Rate = $.trim($rowid.find("#tdRate").text());
                         ObjComDt.Quantity = $.trim($rowid.find("#txtQuantity").val());
                         ObjComDt.rateListID = $.trim($rowid.find("#tdRateListID").text());
                         ObjComDt.ComponentName = $.trim($rowid.find("#tdComponentName").text());
                         ObjComDt.patientRequestedID = Number($.trim($rowid1.find("#tdRequestID").text()));
                         dataComDt.push(ObjComDt);
                         ObjComDt = new Object();
                     }
                 }
             });
             dataGridDt.push(dataComDt);
             ObjGridDt = new Object();
         }
     }
             });
             return dataGridDt;
         }
    </script>

    <script id="tb_dietComponentAttendent" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tbl_DietComponentAttendent" style="width:850px;border-collapse:collapse;">
            <tr id="Tr2">
                <th class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No.
                     <input type="checkbox" class ="chkAllAttendent"  onclick="chkAllAttendent(this)" />
                </th>
                <th class="GridViewHeaderStyle" scope="col" style="width:180px;">Component Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Qty.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;">Rate</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:120px;">Type</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Unit</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Calories</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Protein</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Sodium</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">SaturatedFat</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">T_Fat</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Calcium</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Iron</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">zinc</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;display:none">itemID</th>
            </tr>
            <#
                var dataLength=resultCom.length;
                var objRow;
                for(var j=0;j<dataLength;j++)
                {
                    objRow = resultCom[j];
            #>
            <tr id="trComHeaderAttn" <#if(objRow.PatComDetail !="0"){#> style="background-color:#00cc44;" <#}#>>
                <td class="GridViewLabItemStyle"><#=j+1#>
                    <input type="checkbox" id="chkSelectAttn" onclick="bindRateAttendent(this)"  class="chkAttn" />
                </td>
                <td class="GridViewLabItemStyle" id="tdComponentNameAttn"  style="width:40px;text-align:left" ><#=objRow.ComponentName#></td>
                <td class="GridViewLabItemStyle" id="tdQtyAttn" style="width:60px;">
                    <input type="text" id="txtQuantityAttn" value="<#=objRow.Qty#>" onkeyup="bindRateAttendent(this)"  style="width:30px" onkeypress="return isNumberKey(event)" class="ItDoseTextinputNum" maxlength="4" />
                </td>
                <td class="GridViewLabItemStyle" id="tdRateAttn" style="width:120px;"><#=objRow.Rate#></td>                   
                <td class="GridViewLabItemStyle" id="tdTypeAttn"  style="width:40px;text-align:left" ><#=objRow.Type#></td>
                <td class="GridViewLabItemStyle" id="tdUnitAttn" style="width:120px;"><#=objRow.Unit#></td> 
                <td class="GridViewLabItemStyle" id="tdCaloriesAttn"  style="width:40px;text-align:left" ><#=objRow.Calories#></td>
                <td class="GridViewLabItemStyle" id="tdProteinAttn" style="width:120px;"><#=objRow.Protein#></td>
                <td class="GridViewLabItemStyle" id="tdSodiumAttn"  style="width:40px;text-align:left" ><#=objRow.Sodium#></td>
                <td class="GridViewLabItemStyle" id="tdSaturatedFatAttn" style="width:120px;"><#=objRow.SaturatedFat#></td> 
                <td class="GridViewLabItemStyle" id="tdT_FatAttn"  style="width:40px;text-align:left" ><#=objRow.T_Fat#></td>
                <td class="GridViewLabItemStyle" id="tdCalciumAttn" style="width:120px;"><#=objRow.Calcium#></td>
                <td class="GridViewLabItemStyle" id="tdIronAttn"  style="width:40px;text-align:left" ><#=objRow.Iron#></td>
                <td class="GridViewLabItemStyle" id="tdzincAttn" style="width:120px;"><#=objRow.zinc#></td> 
                <td class="GridViewLabItemStyle" id="tdItemIDAttn" style="width:120px;display:none"><#=objRow.ItemID#></td> 
                <td class="GridViewLabItemStyle" id="tdTransaction_IDAttn" style="width:120px;display:none"><#=objRow.Transaction_ID#></td> 
                <td class="GridViewLabItemStyle" id="tdIPDCaseTypeIDAttn" style="width:120px;display:none"><#=objRow.IPDCaseTypeID#></td> 
                <td class="GridViewLabItemStyle" id="tdRoom_IDAttn" style="width:120px;display:none"><#=objRow.Room_ID#></td>
                <td class="GridViewLabItemStyle" id="tdDietTimeIDAttn" style="width:120px;display:none"><#=objRow.dietTimeID#></td> 
                <td class="GridViewLabItemStyle" id="tdSubDietAttn" style="width:120px;display:none"><#=objRow.SubDietID#></td> 
                <td class="GridViewLabItemStyle" id="tdDietMenuIDAttn" style="width:120px;display:none"><#=objRow.DietMenuID#></td>
                <td class="GridViewLabItemStyle" id="tdDietIDAttn" style="width:120px;display:none"><#=objRow.DietID#></td>
                <td class="GridViewLabItemStyle" id="tdIsFreezeDietAttn" style="width:120px;display:none"><#=objRow.IsFreeze#></td>
                <td class="GridViewLabItemStyle" id="tdComponentIDAttn" style="width:120px;display:none"><#=objRow.ComponentID#></td>
                <td class="GridViewLabItemStyle" id="tdPIDAttn" style="width:120px;display:none"><#=objRow.Patient_ID#></td>
                <td class="GridViewLabItemStyle" id="tdRateListIDAttn" style="width:120px;display:none"><#=objRow.RateListID#></td>
                <td class="GridViewLabItemStyle" id="tdPatComDetailAttn" style="width:120px;display:none"><#=objRow.PatComDetail#></td>
                <td class="GridViewLabItemStyle" id="tdPanelID1Attn" style="width:120px;display:none"><#=objRow.PanelID#></td>
                <td class="GridViewLabItemStyle" id="tdPatientType1Attn" style="width:120px;display:none"><#=objRow.PatientType#></td>
            </tr>
            <#}#>       
        </table>
    </script>

    <script type="text/javascript">

        function closeComponentAttendent() {
            $('#pnlDietComponentAttendent').hide();
        }
        function bindTotalRateAttendent() {
            var totalRate = 0;
            var chkCount = 0;
            $("#tbl_DietComponentAttendent").find("#chkSelectAttn").each(function () {
                var id = $(this).closest("tr").attr("id");
                $row = $(this).closest('tr');
                if ($row.find('#chkSelectAttn').attr("checked")) {
                    var rate = parseFloat($row.find('#tdRateAttn').text());
                    if (isNaN(rate) || rate == "")
                        rate = 0;
                    chkCount += 1;
                    totalRate += parseFloat(rate);
                }
                $("#spnTotalRateAttn").text(totalRate);
            });

            if (chkCount > 0) {
                $("#btnSaveComponentAttn").show();
            }
            else {
                $("#btnSaveComponentAttn").hide();
            }
        }

        function bindRateAttendent(rowID) {
            var totalRate = 0;
            var chkCount = 0;
            $("#tbl_DietComponentAttendent").find("#chkSelectAttn").each(function () {
                var id = $(this).closest("tr").attr("id");
                $row = $(this).closest('tr');
                if ($row.find('#chkSelectAttn').attr("checked")) {
                    var rate = parseFloat($row.find('#tdRateAttn').text());
                    var Qty = parseFloat($row.find('#txtQuantityAttn').val());
                    if (isNaN(Qty) || Qty == "") {
                        Qty = 1;
                        $row.find('#txtQuantityAttn').val(1);
                    }
                    if (isNaN(rate) || rate == "")
                        rate = 0;
                    chkCount += 1;
                    totalRate += parseFloat(parseFloat(rate) * parseFloat(Qty));
                }
                $("#spnTotalRateAttn").text(totalRate);
            });
            if (chkCount > 0) {
                $("#btnSaveComponentAttn").show();
            }
            else {
                $("#btnSaveComponentAttn").hide();
            }
        }
        function chkAllAttendent(rowID) {
            if ($(".chkAllAttendent").is(':checked'))
                $(".chkAttn").prop('checked', 'checked');
            else
                $(".chkAttn").prop('checked', false);
            bindTotalRateAttendent();
        }
        function dietComponentDetailAttendent() {
            var dataComDt = new Array();
            var ObjComDt = new Object();
            $("#tbl_DietComponentAttendent tr").each(function () {
                var id = $(this).closest("tr").attr("id");
                $rowid = $(this).closest('tr');
                if (id != "Tr2") {
                    if ($(this).find("#chkSelectAttn").is(":checked")) {
                        ObjComDt.Transaction_ID = $.trim($rowid.find("#tdTransaction_IDAttn").text());
                        ObjComDt.IPDCaseTypeID = $.trim($rowid.find("#tdIPDCaseTypeIDAttn").text());
                        ObjComDt.ItemID = $.trim($rowid.find("#tdItemIDAttn").text());
                        ObjComDt.RoomID = $.trim($rowid.find("#tdRoom_IDAttn").text());
                        ObjComDt.SubDietID = $.trim($rowid.find("#tdSubDietAttn").text());
                        ObjComDt.DietMenuID = $.trim($rowid.find("#tdDietMenuIDAttn").text());
                        ObjComDt.DietTimeID = $.trim($rowid.find("#tdDietTimeIDAttn").text());
                        ObjComDt.DietID = $.trim($rowid.find("#tdDietIDAttn").text());
                        ObjComDt.RequestDate = $.trim($("#txtDate").val());
                        ObjComDt.IsFreeze = $.trim($rowid.find("#tdIsFreezeDietAttn").text());
                        ObjComDt.ComponentID = $.trim($rowid.find("#tdComponentIDAttn").text());
                        ObjComDt.Patient_ID = $.trim($rowid.find("#tdPIDAttn").text());
                        ObjComDt.Rate = $.trim($rowid.find("#tdRateAttn").text());
                        ObjComDt.Quantity = $.trim($rowid.find("#txtQuantityAttn").val());
                        ObjComDt.rateListID = $.trim($rowid.find("#tdRateListIDAttn").text());
                        ObjComDt.ComponentName = $.trim($rowid.find("#tdComponentNameAttn").text());
                        ObjComDt.PanelID = $.trim($rowid.find("#tdPanelID1Attn").text());
                        ObjComDt.PatientType = $.trim($rowid.find("#tdPatientType1Attn").text());

                        dataComDt.push(ObjComDt);
                        ObjComDt = new Object();
                    }
                }
            });
            return dataComDt;
        }
        function saveComponentAttendent() {
            $('#btnSaveComponentAttn').attr('disabled', true).val("Submitting...");

            var ComponentDetail = dietComponentDetailAttendent();
            var requestID = $("#spnRequestIDAttn").text();
            var Remarks = $("#txtDietRemarksAttn").val();

            $.ajax({
                url: "PatientDietRequest.aspx/saveComponentAttendent",
                data: JSON.stringify({ ComponentDetail: ComponentDetail, requestID: requestID, Remarks: Remarks }),
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: "120000",
                dataType: "json",
                success: function (result) {
                    OutPut = result.d;
                    if (result.d != "0" && result.d != "2") {
                        DisplayMsg('MM01', 'lblMsg');
                        var data = result.d;
                       $("#tbl_DietSearch #" + $("#spnRowIDAttn").text()).closest("tr").find("#tdAttnRequestID").text(data.split('#')[0]);
                       $("#tbl_DietSearch #" + $("#spnRowIDAttn").text()).closest("tr").find("#tdAttnRemarks").text(data.split('#')[1]);
                    }
                    else {
                        DisplayMsg('MM05', 'lblMsg');
                    }
                    $('#btnSaveComponentAttn').attr('disabled', false).val("Save");
                    $("#txtDietRemarksAttn").val('')
                    $('#pnlDietComponentAttendent').hide();
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblMsg');
                    $('#btnSaveComponentAttn').attr('disabled', false).val("Save");
                    $('#pnlDietComponentAttendent').hide();
                }
            });
        }

        function receivedDiet(rowID) {
            $(rowID).closest('tr').find("#btnReceive").attr('disabled', true).val("Submitting...");

            var RequestID = $(rowID).closest('tr').find("#tdRequestID").text();


            $.ajax({
                url: "PatientDietRequest.aspx/receivedDiet",
                data: '{RequestID:"' + RequestID + '"}',
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: "120000",
                dataType: "json",
                success: function (result) {
                    OutPut = result.d;
                    if (result.d == "1") {
                        DisplayMsg('MM01', 'lblMsg');
                    }
                    else {
                        DisplayMsg('MM05', 'lblMsg');
                    }
                    $(rowID).closest('tr').find("#btnReceive").attr('disabled', true)
                    searchDiet();
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblMsg');
                    $(rowID).closest('tr').find("#btnReceive").attr('disabled', true)

                }
            });
        }
    </script>
        


    <div id="pnlDietComponent"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width: auto;height: auto;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="pnlDietComponent" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Component Name </h4>
				</div>
				<div class="modal-body">
					 				<div class="row" ">
                                      <table  style="width: 100%; border-collapse:collapse" id="Table1">
                <tr style="width:100%;border-collapse:collapse">
                    <td colspan="4">
                        <div id="divDietComponent" style="max-height: 500px; overflow-x: auto;">
                        </div>
                        <br />
                        
                    </td>
                </tr>
                 <tr style="width:100%;border-collapse:collapse">
                    <td  style="width:50%" colspan="2">
                   
                        </td>
                     
                      <td  style="width:50%;text-align:left" colspan="2">
                          
                          </td>
                     </tr>
            </table>    
                    
				</div> 
				</div>
				  <div class="modal-footer" style="text-align:center;"> 
                                  <span id="spnTotalRatelabel" style="display:none;" >  Total Rate :</span><span id="spnTotalRate" class="ItDoseLabelSp" style="display:none;" ></span>
                <input type="button" class="ItDoseButton" value="Save" id="btnSaveComponent" style="display:none" onclick="saveComponent()" />
				</div>
			</div>
		</div>
	</div>
    <%--   <cc1:ModalPopupExtender ID="pnlDietComponent" runat="server" BackgroundCssClass="filterPupupBackground"
                    CancelControlID="btnRCancel" DropShadow="true" PopupControlID="pnlDietComponent"  
                    TargetControlID="btnHideOld" OnCancelScript="cancelDietComponent()"  BehaviorID="pnlDietComponent">
                </cc1:ModalPopupExtender>--%>
    <asp:Button ID="btnHideOld" runat="server" Style="display:none" />

    <asp:Button ID="btnRCancel" runat="server" Style="display:none" />
     

        <asp:Button ID="btnHideAttn" runat="server" Style="display:none" />

    <div id="pnlDietComponentAttendent"  class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content" style="background-color:white;width: auto;height: auto;">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="pnlDietComponentAttendent" aria-hidden="true">&times;</button>
					<h4 class="modal-title">Attendent Component Name </h4>
				</div>
				<div class="modal-body">
					 				<div class="row" ">
                                                     <span id="spnRequestIDAttn" style="display:none;"></span>
            <span id="spnRowIDAttn" style="display:none;"></span>
                                                   <table  style="width: 100%; border-collapse:collapse" id="Table2">
                <tr style="width:100%;border-collapse:collapse">
                    <td colspan="4">
                        <div id="divDietComponentAttendent" style="max-height: 500px; overflow-x: auto;"></div>
                        <br />                        
                    </td>
                </tr>
            </table>
            <table style="width: 100%; border-collapse:collapse" >
                <tr style="width:100%;border-collapse:collapse">
                    <td style="width:10%; text-align:right">Comment :&nbsp;</td>
                    <td style="width:90%;text-align:left" colspan="2">
                        <input type="text" maxlength="30" id="txtDietRemarksAttn" style="width:700px" />
                    </td>
                </tr>
                <tr style="width:100%;border-collapse:collapse">
                    <td  style="width:10%; text-align:right"">Total Rate :&nbsp;</td>
                    <td  style="width:40%; text-align:left"">
                        <span id="spnTotalRateAttn" class="ItDoseLabelSp"></span>
                    </td> 
                </tr>
            </table>
                    
				</div> 
				</div>
				  <div class="modal-footer" style="text-align:center;">  
         <input type="button" class="ItDoseButton" value="Save" id="btnSaveComponentAttn" style="display:none" onclick="saveComponentAttendent();" />
				</div>
			</div>
		</div>
	</div>

        <%--<cc1:ModalPopupExtender ID="mpDietComponentAttendent" runat="server" BackgroundCssClass="filterPupupBackground"
                    CancelControlID="btnRCancel" DropShadow="true" PopupControlID="pnlDietComponentAttendent"  
                    TargetControlID="btnHideAttn" OnCancelScript="cancelDietComponentAttendent()"  BehaviorID="mpDietComponentAttendent">
        </cc1:ModalPopupExtender>--%>  
   <script type="text/javascript">
       function isNumberKey(evt) {
           var charCode = (evt.which) ? evt.which : event.keyCode
           if (charCode > 31 && (charCode < 48 || charCode > 57))
               return false;
           return true;
       }
   </script>
</asp:Content>

