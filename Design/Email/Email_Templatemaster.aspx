<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Email_Templatemaster.aspx.cs" Inherits="Design_Email_Email_Templatemaster" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
        <script type="text/javascript" src="../../Scripts/jquery.extensions.js"></script>
    <script type="text/javascript" src="../../Scripts/json2.js"></script>
   

    <div id="Pbody_box_inventory">
          <cc1:ToolkitScriptManager ID="ToolkitScriptManager1" runat="server" EnableScriptGlobalization="true"
            EnableScriptLocalization="true">
        </cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Email Template Master</b>
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">Template Master</div>
             <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Template Name</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5"><input type="text" id="txtName" class="requiredField"  />
                          <span id="spnID" style="display:none"></span></div>
                        <div class="col-md-3">
                            <label class="pull-left">Status</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbestatus" runat="server" RepeatDirection="Horizontal" ClientIDMode="Static">
                            <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                            <asp:ListItem Value="0">Deactive</asp:ListItem>
                        </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Schedule Type</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddltype"  runat="server" ClientIDMode="Static" onchange="check()" CssClass="requiredField" >
                          <asp:ListItem Value="0" Text="Select"></asp:ListItem>
                          <asp:ListItem Value="1" Text="Daily"></asp:ListItem>
                           <asp:ListItem Value="2" Text="Monthly"></asp:ListItem>
                           <asp:ListItem Value="3" Text="Run Time"></asp:ListItem>
                      </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Schedule Time</label><b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:TextBox runat="server" ID="txttime" ClientIDMode="Static"></asp:TextBox>
                         <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time" 
                                TargetControlID="txttime" AcceptAMPM="true">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txttime"
                                ControlExtender="masTime" IsValidEmpty="false" EmptyValueMessage="Time Required"
                                InvalidValueMessage="Invalid Time"></cc1:MaskedEditValidator>
                    </div>
                    <div class="col-md-3">
                        <label class="pull-left">Schedule Date</label><b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        
                     <asp:TextBox ID="txtdate" runat="server" ToolTip="Select From Date"
                            TabIndex="1" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="clcAppDate" runat="server" TargetControlID="txtdate"
                            Format="dd-MMM-yyyy" ClearTime="true">
                        </cc1:CalendarExtender>
                    </div>
                        <div class="col-md-3"><label class="pull-left">Repeat Type</label><b class="pull-right">:</b> </div>
                        <div class="col-md-2"><asp:TextBox ID="txtrepeatparameter" runat="server" ClientIDMode="Static" CssClass="required" Width="87px" TextMode="Number"> </asp:TextBox></div>
                        <div class="col-md-3"><asp:DropDownList ID="ddlemailrepeattype" runat="server" ClientIDMode="Static" CssClass="required">
                            <asp:ListItem Value="0">SELECT</asp:ListItem>
                            <asp:ListItem Value="MINUTE">MINUTE</asp:ListItem>
                            <asp:ListItem Value="HOUR">HOUR</asp:ListItem>
                            <asp:ListItem Value="DAY">DAY</asp:ListItem>
                            <asp:ListItem Value="Month">MONTH</asp:ListItem>
                            <asp:ListItem Value="WEEK">WEEK</asp:ListItem>
                        </asp:DropDownList></div>
                    </div>
                        <div class="row">

                     <div class="col-md-3">
                         <label class="pull-left">PanelWise</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                         <select id="ddlPanelWise"> 
                             <option value="0">No</option>
                             <option value="1">Yes</option>
                         </select>
               </div>
            </div>

                    
            
                    


                    
                </div><div class="col-md-1"></div></div>
        </div>
          <div class="POuter_Box_Inventory textCenter" >
                   <input type="button" class="save margin-top-on-btn" id="Btnsearch"  value="Save" onclick="savedetails()"  />
                   <input type="button" class="save margin-top-on-btn" id="btnupdate"  value="Update" style="display:none" onclick="UpdateDetails()"  />
          </div>


          <div class="POuter_Box_Inventory" id="divINV">
             <div class="Purchaseheader">
                Results
                </div>

             <table cellpadding="0" cellspacing="0" style="width: 100%" id="myTable">
                <tr >
                    <td colspan="4">
                        <div id="TemplateOutPut" style="max-height: 470px; overflow-x: auto;">
                        </div>
                    </td>
                </tr>
            </table>
             </div>
        <div class="POuter_Box_Inventory hide" style="text-align: center; display: none;">
        </div>
    </div>
    <script type="text/javascript">
        
        function check()
        {
            if ($("#ddltype").val() == "1") {
                $("#txtdate").attr('disabled', 'disabled');
                $("#txttime,#txtrepeatparameter,#ddlemailrepeattype").removeAttr('disabled');
            }
           else if ($("#ddltype").val() == "2") {
               $("#txtdate,#txtrepeatparameter,#ddlemailrepeattype").removeAttr('disabled');
                $("#txttime").removeAttr('disabled');
            }
           else if ($("#ddltype").val() == "3") {
               $("#txtdate,#txtrepeatparameter,#ddlemailrepeattype").attr('disabled', 'disabled');
                $("#txttime").attr('disabled', 'disabled');
            }
            else {
               $("#txtdate,#txtrepeatparameter,#ddlemailrepeattype").attr('disabled', 'disabled');
                $("#txttime").attr('disabled', 'disabled');
            }
        }
        var msg = true;
        function savedetails() {
            var Templatename = $("#txtName").val();
            var Templatenametype = $("#ddltype").val();
            var ScheduleTime = $("#txttime").val();
            var ScheduleDate = $("#txtdate").val();
            var Status = $("[id$='rbestatus']").find(":checked").val();
            if (Templatename == "") {
                modelAlert('Please Enter The Template Name');
                return;
            }
            if (Templatenametype == "0") {
                modelAlert('Select the Schedule Type');
                return;
            }
            if (Templatenametype == "1") {

                ScheduleTime = $("#txttime").val();
                ScheduleDate = "";
                if (ScheduleTime == "") {
                    modelAlert('Please Enter the Schedule Time');
                    return;
                }
                if ($('#txtrepeatparameter').val() == "" && $('#txtrepeatparameter').val() == "") {
                    modelAlert("Please Enter The Repeat Time.")
                    return;
                }
                if ($('#ddlemailrepeattype').val() == "0") {
                    modelAlert("Please Enter The Repeat Type.")
                    return;
                }
            }
            else if (Templatenametype == "2") {
                ScheduleTime = $("#txttime").val();
                ScheduleDate = $("#txtdate").val();
                if (ScheduleTime == "") {
                    alert('Please Enter the Schedule Time');
                    return;
                }
                if (ScheduleDate == "") {
                    alert('Please Enter the Schedule Date');
                    return;
                }
                if ($('#txtrepeatparameter').val() == "" && $('#txtrepeatparameter').val() == "") {
                    modelAlert("Please Enter The Repeat Time.")
                    return;
                }
                if ($('#ddlemailrepeattype').val() == "0") {
                    modelAlert("Please Enter The Repeat Type.")
                    return;
                }
            }
            

            var isPanelWise=Number($('#ddlPanelWise').val());


            $.ajax({
                url: "Email_Templatemaster.aspx/SaveEmailTemplate",
                data: JSON.stringify({ "TemplateName": Templatename, "Status": Status, "ScheduleType": Templatenametype, "ScheduleTime": ScheduleTime, "ScheduleDate": ScheduleDate, isPanelWise: isPanelWise, emailrepeattype: $('#ddlemailrepeattype').val(), repeatparameter: $('#txtrepeatparameter').val() }),
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: "120000",
                dataType: "json",
                async: false,
                success: function (result) {
                   var OutPut = result.d;
                   if (OutPut == "1") {
                       window.location.reload(0);
                        $('#lblMsg').text('Record Save Successfully');
                        //BindDetails();
                    }
                    else {
                        $('#lblMsg').text('Record Not Saved Successfully');
                    }
                },
                error: function (xhr, status) {
                    $("#spnErrorMsg").text('Error occurred, Please contact administrator');
                }
            });


        }
       
        $(document).ready(function () {
            BindDetails();
            check();
        })
        function BindDetails() {
            $.ajax({
                type: "POST",
                url: "Email_Templatemaster.aspx/BindTemplateMaster",
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                timeout: 120000,
                async: false,
                success: function (result) {
                    MyDate = jQuery.parseJSON(result.d);
                    if (MyDate != null) {
                        var output = $('#tb_TemplateSearch').parseTemplate(MyDate);
                        $('#TemplateOutPut').html(output);
                        $('#TemplateOutPut').show();
                    }
                    else {
                        $("#TemplateOutPut").html("");
                    }
                    $("#btnSearch").removeProp('disabled');
                },
                error: function (xhr, status) {
                    $("#lblMsg").text('Error occurred, Please contact administrator');
                    $("#btnSearch").removeProp('disabled');
                    $("#TemplateOutPut").html("");
                }
            });
        }
        function Edit(rowid) {
            $("#lblmsg").text('');
            var ID = $(rowid).closest('tr').find("#ID").text();
            $("#btnupdate").show();
            $("#Btnsearch").hide();

            var data = JSON.parse($(rowid).closest('tr').find('.tdData').text());
            $('#ddlPanelWise').val(data.IsPanelWise);

            $("#txtName").val($(rowid).closest('tr').find("#templatename").text());
            $("#rbestatus").val($(rowid).closest('tr').find("#Status").text());
            $("#txttime").val($(rowid).closest('tr').find("#txtscheduletime").text());
            $("#txttime").val($(rowid).closest('tr').find("#txtscheduletime").text());
            $("#txttime").val($(rowid).closest('tr').find("#txtscheduletime").text());
            var ss = $(rowid).closest('tr').find("#txtscheduletype").text();
            if (ss == "Monthly") {
                $("#ddltype").val(2);
            }
            else if (ss == "Daily") {
                $("#ddltype").val(1);
            }
            else {
                $("#ddltype").val(3);
            }
            var rbstatus = $(rowid).closest('tr').find("#Status").text();
            if (rbstatus == "Active") {

                $("#rbestatus").prop("checked")
            }
            else {
                $("#rbestatus").prop("checked")
            }
            $("#spnID").text(ID);
            check();
        }
        function UpdateDetails() {
            var Status = $("[id$='rbestatus']").find(":checked").val();
            var Templatenametype = $("#ddltype").val();
            var Templatename = $("#txtName").val();
            var ScheduleTime = $("#txttime").val();
            var ScheduleDate = $("#txtdate").val();
            var isPanelWise = Number($('#ddlPanelWise').val());


            var ID = $("#spnID").text();
            $.ajax({
                url: "Email_Templatemaster.aspx/UpdateType",
                data: '{ID:"' + ID + '", "TemplateName": "' + Templatename + '", "Status": "' + Status + '", "ScheduleType": "' + Templatenametype + '", "ScheduleTime": "' + ScheduleTime + '", "ScheduleDate": "' + ScheduleDate + '", "IsPanelWise": "' + isPanelWise + '", "emailrepeattype": "'+ $('#ddlemailrepeattype').val() +'", "repeatparameter": "'+ $('#txtrepeatparameter').val() +'" }',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        window.location.reload(0);
                        $('#lblMsg').text('Record Update Successfully');
                        //BindDetails();
                    }
                    $("#btnUpdate").removeAttr('disabled');
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
    </script>
    <script id="tb_TemplateSearch" type="text/html">
    <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="Table1" style="width:100%;border-collapse:collapse;">
		<tr id="Header">
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">Sno</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:160px;">Template Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:79px;">Status</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:19%;">Schedule Type</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:60px;">Schedule Time</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Schedule Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Repeat Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:60px;">Edit</th>
		</tr>
        <#
        var dataLength=MyDate.length;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {
        objRow = MyDate[j];
          #>
                   <tr>
                       <td  class="GridViewLabItemStyle" ><#=j+1#></td>
                        <td id="ID" class="GridViewLabItemStyle" style="display:none" ><#=objRow.ID#></td>
                        <td id="Td1" class="GridViewLabItemStyle tdData" style="display:none" ><#= JSON.stringify(objRow) #></td>
                        <td id="templatename" class="GridViewLabItemStyle"><#=objRow.TemplateName#></td>
                        <td  id="Status" class="GridViewLabItemStyle"><#=objRow.STATUS#></td>
                        <td  id="txtscheduletype" class="GridViewLabItemStyle"><#=objRow.ScheduleType#></td>
                        <td  id="txtscheduletime" class="GridViewLabItemStyle"><#=objRow.ScheduleTime#></td>
                        <td  id="txtscheduledate" class="GridViewLabItemStyle"><#=objRow.ScheduleDate#></td>
                       <td  id="tdRepeatType" class="GridViewLabItemStyle"><#=objRow.Email_repeat#></td>
                        <td class="GridViewLabItemStyle" id="tdDelete" style="text-align:center;">
                        <img id="imgRmv" src="../../Images/edit.png" onclick="Edit(this)"  title="Edit"/>
                        </td>
                </tr>   
            <#}#>
     </table>    
    </script>
</asp:Content>


