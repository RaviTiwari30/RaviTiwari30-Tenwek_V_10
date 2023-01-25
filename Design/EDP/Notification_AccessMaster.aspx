<%@ Page  Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Notification_AccessMaster.aspx.cs" Inherits="Design_EDP_Notification_AccessMaster" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
     <div id="Pbody_box_inventory">
   
        <cc1:ToolkitScriptManager ID="ToolkitScriptManager1"  runat="server">
        </cc1:ToolkitScriptManager>
        <div style="text-align: center" class="POuter_Box_Inventory">
            <b>Notification Access Master</b>
            <br />
            <span id="spnMsg" class="ItDoseLblError"></span>
        </div>
        
                 <div class="POuter_Box_Inventory" style="text-align:center">
            <table  style="width: 100%; border-collapse:collapse">
                <tr >
                    <td colspan="4">
                        <div id="notificationSearchOutput" style="max-height: 500px; overflow-x: auto;">
                        </div>
                        <br />
                        
                    </td>
                </tr>
            </table>

                     </div>
        
     </div>
    
    <script type="text/javascript">
        $(function () {
            bindNotification();
        });
        function bindNotification() {
            $("#spnMsg").text('');
            $.ajax({
                url: "Notification_AccessMaster.aspx/bindNotification",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    notificationData = jQuery.parseJSON(result.d);
                    if (notificationData.length > 0) {
                        var output = $('#tb_notification').parseTemplate(notificationData);
                        $('#notificationSearchOutput').html(output);
                        $('#notificationSearchOutput').show();
                        $('#tbl_NotificationSearch tr').bind('mouseenter mouseleave', function () {
                            $(this).toggleClass('hover');

                        });
                    }
                    else {
                        $('#notificationSearchOutput').html();
                        $('#notificationSearchOutput').hide();
                    }
                },
                error: function (request) {
                    $("#spnMsg").text('Error occurred, Please contact administrator');
                }
            });
        }

    </script>
         <script id="tb_notification" type="text/html">
   <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tbl_NotificationSearch"
        style="width:100%;border-collapse:collapse;">
             <tr id="Tr1">
                <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:40px;display:none">NotificationID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:180px;">NotificationType</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:240px;">Description</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">IsEmployee</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;">IsLogin</th>
                                

            </tr>
            <#
            var dataLength=notificationData.length;
        var objRow;
     
        for(var j=0;j<dataLength;j++)
        {
            objRow = notificationData[j];
        #>
             
                    <tr id="trNotificationHeader">
                    <td class="GridViewLabItemStyle"><#=j+1#>  </td>
                    <td class="GridViewLabItemStyle" id="tdNotificationID"  style="width:40px;text-align:left;display:none" ><#=objRow.NotificationID#></td>              
                    <td class="GridViewLabItemStyle" id="tdNotificationType"  style="width:180px;text-align:left" ><#=objRow.NotificationType#></td>
                    <td class="GridViewLabItemStyle" id="tdDescription"  style="width:240px;text-align:left"  ><#=objRow.Description#></td>
                    <td class="GridViewLabItemStyle" id="tdIsEmployee"  style="width:40px;text-align:center" >                       
                               <input type="checkbox" id="chkIsEmployee" onclick="IsEmployee(this)" class="isEmployee"
                                   <%-- <#if(objRow.IsDependent=="0"){#>disabled="disabled"<#}#>--%>/>                                                         
                    </td>
                    <td class="GridViewLabItemStyle" id="tdIsLogin"  style="width:40px;text-align:center"  >
                               <input type="checkbox" id="chkIsLogin" onclick="IsLogin(this)" class="isLogin"
                                   <%-- <# if(objRow.IsDependent=="0"){#>disabled="disabled"  <#} #> --%>/>                       
                    </td> 
                       
                    </tr>
        <#}       #>    
     </table>
    </script>
    <script type="text/javascript">

        function IsEmployee(rowID) {
            if ($(rowID).closest('tr').find("#chkIsEmployee").is(':checked')) {
                $(rowID).closest('tr').find("#chkIsLogin").attr('checked', false);
                $find('mpNotification').show();
                $('#spnSaveType').text("IsEmp");
                $('#spnNotificationName').text($(rowID).closest('tr').find('#tdNotificationType').text());
                $('#spnNotificationID').text($(rowID).closest('tr').find('#tdNotificationID').text());
                bindSearchType();
            }
        }
        function IsLogin(rowID) {
            if ($(rowID).closest('tr').find("#chkIsLogin").is(':checked')) {
                $(rowID).closest('tr').find("#chkIsEmployee").attr('checked', false);
                $find('mpNotification').show();
                $('#spnSaveType').text("IsRole");
                $('#spnNotificationName').text($(rowID).closest('tr').find('#tdNotificationType').text());
                $('#spnNotificationID').text($(rowID).closest('tr').find('#tdNotificationID').text());
                bindSearchType();
            }
        }
        function closePopUp() {
            $find('mpNotification').hide();
            $("#divEmpDetail").html('');
            $('#btnSave,#trNotification').hide();
            $("#spnNotification").text('');
        }
    </script>
    <script type="text/javascript">
        function bindSearchType() {
            $("#spnMsg").text('');
            if ($('#tblSearchType tr').length == 0) {
                $.ajax({
                    url: "Notification_AccessMaster.aspx/bindSearchType",
                    data: '{}',
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    async: false,
                    dataType: "json",
                    success: function (result) {
                        searchingData = jQuery.parseJSON(result.d);
                        if (searchingData.length > 0) {
                            $("#trNotification").hide();
                            $("#spnNotification").text('');
                            $('#tblSearchType').html('');
                            var tableApp = $("<tr>");
                            for (var i = 0; i < searchingData.length; i++) {
                                var newListItem = '<a title="' + searchingData[i].SearchType + '" onclick="bindEmpDetail(\'' + searchingData[i].SearchType + '\')"  href="javascript:void(0);"   id="' + searchingData[i].SearchType + '" >' + searchingData[i].SearchType + '</a>';
                                tableApp.append("<td style='width:4%'>" + newListItem + "</td>");
                            }
                            tableApp.append('</tr>');
                            $('#tblSearchType').append(tableApp);
                        }
                        else {
                           
                        }
                    },
                    error: function (request) {
                        $("#spnMsg").text('Error occurred, Please contact administrator');
                    }
                });
            }
        }
    </script>
        <script type="text/javascript">
        function getSearchType(SearchType) {
            $.ajax({
                url: "Notification_AccessMaster.aspx/bindEmployee",
                data: '{SearchType:"' + SearchType + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    empData = jQuery.parseJSON(result.d);

                    $('#dvChklControl').html('');

                    var table = $('<table></table>');
                    var counter = 0;
                    $(empData).each(function () {
                        table.append($('<tr></tr>').append($('<td_' + this.Employee_ID + '></td>').append($('<input>').attr({
                            type: 'checkbox', name: 'chklistItem', value: this.Employee_ID, id: 'chklistItem' + counter, onclick: 'chkLogin(\'' + this.Employee_ID + '\')'
                        })).append(
                        $('<label>').attr({
                            for: 'chklistItem' + counter++
                        }).text(this.EmpName))).append($('<td_' + this.Employee_ID + '></td>')));
                    });

                    $('#dvChklControl').append(table);
                },
                error: function (request) {
                    $("#spnMsg").text('Error occurred, Please contact administrator');

                }

            });
        }
        function chkLogin(employee_ID) {
            $.ajax({
                url: "Notification_AccessMaster.aspx/bindLoginType",
                data: '{employee_ID:"' + employee_ID + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    loginData = jQuery.parseJSON(result.d);
                    $('#dvChklControlLogin').html('');

                    var table = $('<table style="width:100%;border-collapse:collapse"></table>');
                    var counter = 0;
                    table.append($('<tr style="width:100%;border-collapse:collapse"></tr>'));
                    $(loginData).each(function () {
                        table.append($('<td style="border-collapse:collapse"></td>').append($('<input>').attr({
                            type: 'checkbox', name: 'chklistItem', value: this.ID, id: 'chklistItem' + counter, onclick: 'chkRole(\'' + this.ID + '\')'
                        })).append(
                        $('<label>').attr({
                            for: 'chklistItem' + counter++
                        }).text(this.RoleName)));
                    });

                    $('#dvChklControlLogin').append(table);

                },
                error: function (request) {
                    $("#spnMsg").text('Error occurred, Please contact administrator');

                }

            });
        }
    </script>
        <asp:Panel ID="pnlNotificationOld" runat="server" CssClass="pnlItemsFilter" Style="display: none;max-height: 500px; overflow-x: auto;"  
                    Width="1100px"  >
                 <div class="Purchaseheader">  
                        Notification&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
              <em ><span style="font-size: 7.5pt"> Press esc or click
                            <img src="../../Images/Delete.gif" alt="" style="cursor:pointer"  onclick="closePopUp()"/>
                               
                                to close</span></em>
                    </div>
            <table  style="width: 100%; border-collapse:collapse"  >
                <tr style="width:100%;border-collapse:collapse">
                    <td colspan="4">
                    <table id="tblSearchTypeold" style="width: 100%; border-collapse:collapse">
                      
                    </table>
                        </td>
                </tr>
                       <tr style="width:100%;border-collapse:collapse">
                    <td >           
                     <div id="dvChklControl" >             

    </div>
                        </td>
                           <td colspan="3" style="vertical-align:top">
                                <div id="dvChklControlLogin" >    </div>      
                           </td>
                           </tr>       
                           
                    
                 <tr style="width:100%;border-collapse:collapse">
                    <td  style="width:50%" colspan="2">
                        </td>
                     
                      <td  style="width:50%;text-align:left" colspan="2">
                          </td>
                     </tr>
            </table>
                </asp:Panel>
        <cc1:ModalPopupExtender ID="mpNotification" runat="server" BackgroundCssClass="filterPupupBackground"
                    CancelControlID="btnRCancel" DropShadow="true" PopupControlID="pnlNotification"  
                    TargetControlID="btnHideOld" OnCancelScript="closePopUp()"  BehaviorID="mpNotification" Y="57" X="24">
                </cc1:ModalPopupExtender>
    <asp:Button ID="btnHideOld" runat="server" Style="display:none" />
    <asp:Button ID="btnRCancel" runat="server" Style="display:none" />
       <asp:Panel ID="pnlNotification" runat="server" CssClass="pnlItemsFilter" Style="display: none;max-height: 580px; overflow-x: auto;"  
                    Width="1298px"  >
                <div style="text-align: center" class="POuter_Box_Inventory">

                 <div class="Purchaseheader">  
                     <table style="width:100%">
                         <tr>
                             <td style="text-align:left">
                                  Notification
                             </td>
                              <td style="text-align:right">
  <em ><span style="font-size: 7.5pt"> Press esc or click
                            <img src="../../Images/Delete.gif" alt="" style="cursor:pointer"  onclick="closePopUp()"/>                              
                                to close</span></em> </td>
                         </tr>
                        
                     </table>
                      
                    </div>
                   
          <table id="tblSearchType" style="width: 100%; border-collapse:collapse">
                      
                    </table>
                     <table style="width:100%">
                         <tr style="display:none" id="trNotification">
                             <td colspan="2" >
                                 <span id="spnNotification" class="ItDoseLblError" ></span>
                             </td>
                         </tr>
                    </table>
         <div id="divEmpDetail" style="max-height: 500px; overflow-x: auto;">
                        </div>
                                    <div style="text-align: center" class="POuter_Box_Inventory">
                                    <span id="spnSaveType" style="display:none"></span>
                                    <span id="spnNotificationID" style="display:none"></span>
                                    <span id="spnNotificationName" style="display:none"></span>

                                 <input type="button" class="ItDoseButton" value="Save" id="btnSave"  style="display:none" onclick="save()" />

                                        </div>
                    </div>
        </asp:Panel>
       <script id="sc_EmpDetail" type="text/html">
   <table class="FixedTables" cellspacing="0" rules="all" border="1"  id="tbl_empDetail"
        style="width:100%;border-collapse:collapse;">
             <tr id="tr_empDetail">
                <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Employee Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none">Employee_ID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:10px;">All</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:540px;">Login Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:10px;display:none"> </th>
            </tr>
            <#
            var dataLength=empDetailData.length;
        var objRow;
     
        for(var j=0;j<dataLength;j++)
        {
            objRow = empDetailData[j];
        #>            
                    <tr id="tr3">
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#>  </td>
                    <td class="GridViewLabItemStyle" id="tdEmployeeName"  style="width:140px;text-align:left;" >
                    <input type="checkbox" value="<#=objRow.Employee_ID#>" id="chkEmp_<#=objRow.Employee_ID#>" onclick="enableRole(this)"  
                        <#
                        if(objRow.EmpCheck !="0")
                        {#>  checked="checked" <#}
                        #>
                        />
                        <#=objRow.EmployeeName#></td>              
                    <td class="GridViewLabItemStyle" id="tdEmployee_ID"  style="width:80px;text-align:left;display:none" ><#=objRow.Employee_ID#></td>

                        <td class="GridViewLabItemStyle"    id="tdChkAll_<#=objRow.Employee_ID#>" 
                         <# if(objRow.RoleCheck =="0") {#> style="width:10px;text-align:left;display:none" <#} else {#> style="width:10px;text-align:left;"<#} #> >                       
                        <input type="checkbox" id="chkRole" onclick="chkAllRole(this)" />
                    </td>

                          <td class="GridViewLabItemStyle" id="tdEmployee_<#=objRow.Employee_ID#>"  style="width:540px;text-align:left;
                                <# if(objRow.RoleCheck =="0") {#>display:none" <#} else {#> display:block"<#} #> >
                              
                        <#                       
                            var roleLength= parseInt(objRow.RoleID.split('$').length); 
                              var roleChkLength=0;                
                         if(objRow.RoleCheck !="0") 
                              roleChkLength= parseInt(objRow.RoleCheck.split('$').length);                        
                         for(var k=0;k<roleLength;k++)
                        { #>             
                        <input type="checkbox" value="<#=objRow.RoleID.split('$')[k]#>" id="chkRole_<#=objRow.RoleID.split('$')[k]#>" onclick="countRoleCheck(this)" class="roleCheckLength" name="chkRoleEmp_<#=objRow.Employee_ID#>" style="width:24px;text-align:center; vertical-align: middle;margin-left:auto; margin-right:auto;"  
                        <# if(roleChkLength>0){
                              for(var t=0;t<roleChkLength;t++)
                        {#>                                 
                                <# if(objRow.RoleID.split('$')[k]==objRow.RoleCheck.split('$')[t])
                                    { #> checked="checked" <#} #>
                         <#} }#> />     
                                
                             
                             <#=objRow.RoleName.split('$')[k]#>
                             <# if(k=="4" || k=="8" || k=="12" || k=="16" || k=="20" || k=="24" || k=="28" || k=="32" || k=="36")
                             {#><br /><#}#><#}
                        #>
                             </td>             
                                            <td class="GridViewLabItemStyle" style="width:10px;display:none">
                                                <span id="spnEmpChange"  >0</span>
                                            </td>
                           
                    </tr>
        <#}       #>    
     </table>
    </script>
       <script type="text/javascript">
        function chkAllRole(rowID) {
            if ($(rowID).closest('tr').find('#chkRole').is(':checked'))
                $(rowID).closest('tr').find('.roleCheckLength').attr('checked', true);
            else
                $(rowID).closest('tr').find('.roleCheckLength').attr('checked', false);
            countRoleCheck(rowID);
        }
        function countRoleCheck(rowID) {
            if ($("input:checkbox:checked.roleCheckLength").length > 0)
                $("#btnSave").show();
            else
                $("#btnSave").hide();
            if ($(rowID).closest('tr').find('.roleCheckLength').is(':checked'))
                $(rowID).closest('tr').find('#spnEmpChange').text('1');
            else
                $(rowID).closest('tr').find('#spnEmpChange').text('0');


        }
        function enableRole(rowID) {
            employeeID = $(rowID).val();
            if ($(rowID).is(':checked')) {
                $(rowID).closest('tr').find("#tdEmployee_" + employeeID).show();
                $(rowID).closest('tr').find("#tdChkAll_" + employeeID).show();

            }
            else {
                $(rowID).closest('tr').find("#tdEmployee_" + employeeID).hide();
                $(rowID).closest('tr').find(":checkbox").attr("checked", false);
                $(rowID).closest('tr').find("#tdChkAll_" + employeeID).hide();

            }
            countRoleCheck();
        }
    </script>
       <script type="text/javascript">
        function bindEmpDetail(SearchType) {
            $("#spnMsg").text('');
            var isRole = 0, isEmp = 0;
            if ($('#spnSaveType').text() == "IsRole") {
                isRole = 1; isEmp = 0;
            }
            else {
                isEmp = 1; isRole = 0;

            }
            $.ajax({
                url: "Notification_AccessMaster.aspx/bindEmpLoginType",
                data: '{SearchType:"' + SearchType + '",isRole:"' + isRole + '",isEmp:"' + isEmp + '",NotificationID:"'+$("#spnNotificationID").text()+'"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    empDetailData = jQuery.parseJSON(result.d);
                    if (empDetailData.length > 0) {
                        if (isEmp == 1)
                            var output = $('#sc_EmpDetail').parseTemplate(empDetailData);
                        else
                            var output = $('#sc_LoginDetail').parseTemplate(empDetailData);


                        $('#divEmpDetail').html(output);
                        $('#divEmpDetail').show();
                        $("#trNotification").hide();
                        $("#spnNotification").text('');
                    }
                    else {
                        $('#divEmpDetail').html();
                        $('#divEmpDetail').hide();
                        $("#trNotification").show();
                        $("#spnNotification").text('Record Not Found');
                    }
                },
                error: function (request) {
                    $("#spnMsg").text('Error occurred, Please contact administrator');

                }
            });
        }
            </script>
       <script type="text/javascript">
        function empNotificationAccess() {

            var dataNotification = new Array();
            var ObjNotification = new Object();
            if ($('#spnSaveType').text() == "IsEmp") {

                $("#tbl_empDetail tr").each(function () {
                    var id = $(this).attr("id");
                    var $rowid = $(this).closest("tr");
                    if (id != "tr_empDetail") {
                        var employee_ID = $rowid.find("#tdEmployee_ID").text();
                        if ($rowid.find("#chkEmp_" + employee_ID).is(':checked')) {
                            ObjNotification.Employee_ID = $.trim($rowid.find("#tdEmployee_ID").text());
                            ObjNotification.NotificationID = $.trim($("#spnNotificationID").text());
                            ObjNotification.NotificationName = $.trim($("#spnNotificationName").text());
                            var RoleID = "";
                            $('input[name="chkRoleEmp_' + employee_ID + '"]:checked').each(function () {
                                if (RoleID != "")
                                    RoleID += "#" + $(this).val() + "";
                                else
                                    RoleID = "" + $(this).val() + "";
                            });
                            ObjNotification.RoleID = RoleID;
                            dataNotification.push(ObjNotification);
                            ObjNotification = new Object();
                        }
                    }
                });
            }
            else {
                $("#tbl_roleDetail tr").each(function () {
                    var id = $(this).attr("id");
                    var $rowid = $(this).closest("tr");
                    if (id != "tr_roleDetail") {
                        var RoleID = $rowid.find("#tdLoginRoleID").text();

                        if ($rowid.find("#chkRoleID_" + RoleID).is(':checked')) {

                            ObjNotification.RoleID = $.trim($rowid.find("#tdLoginRoleID").text());
                            ObjNotification.NotificationID = $.trim($("#spnNotificationID").text());
                            ObjNotification.NotificationName = $.trim($("#spnNotificationName").text());

                            var Employee_ID = "";
                            $('input[name="chkRoleEmp_' + RoleID + '"]:checked').each(function () {
                                if (Employee_ID != "")
                                    Employee_ID += "#" + $(this).val() + "";
                                else
                                    Employee_ID = "" + $(this).val() + "";
                            });
                            ObjNotification.Employee_ID = Employee_ID;
                            dataNotification.push(ObjNotification);
                            ObjNotification = new Object();
                        }
                    }

                });
            }
            return dataNotification;
        }
    </script>
       <script type="text/javascript">

        function save() {
            $('#btnSave').attr('disabled', true).val("Submitting...");
            var isRole = 0, isEmp = 0;

            if ($('#spnSaveType').text() == "IsRole") {
                isRole = 1; isEmp = 0;
            }
            else {
                isEmp = 1; isRole = 0;

            }
            var notification = empNotificationAccess();
            $.ajax({
                url: "Notification_AccessMaster.aspx/notificationAccess",
                data: JSON.stringify({ notification: notification, isRole: isRole, isEmp: isEmp, NotificationID: $("#spnNotificationID").text() }),
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: "120000",
                dataType: "json",
                success: function (result) {
                    OutPut = result.d;
                    if (result.d == "1") {
                        DisplayMsg('MM01', 'spnMsg');
                    }
                    else {
                        DisplayMsg('MM05', 'spnMsg');
                    }
                    $('#btnSave').attr('disabled', false).val("Save");
                    $("input:checkbox:checked.isEmployee").attr('checked', false);
                    $("input:checkbox:checked.isLogin").attr('checked', false);
                    closePopUp();

                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'spnMsg');
                    $('#btnSave').attr('disabled', false).val("Save");
                }
            });
        }



    </script>
       <script id="sc_LoginDetail" type="text/html">
   <table class="FixedTables" cellspacing="0" rules="all" border="1"  id="tbl_roleDetail"
        style="width:100%;border-collapse:collapse;">
             <tr id="tr_roleDetail">
                <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Login Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none">RoleID</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:10px;">All</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:620px;">Employee Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:10px;display:none"></th>
            </tr>
            <#
            var dataLength=empDetailData.length;
        var objRow;
     
        for(var j=0;j<dataLength;j++)
        {
            objRow = empDetailData[j];
        #>            
                    <tr id="tr4">
                    <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#>  </td>
                    <td class="GridViewLabItemStyle" id="tdLoginRole"  style="width:140px;text-align:left;" >
                    <input type="checkbox" value="<#=objRow.RoleID#>" id="chkRoleID_<#=objRow.RoleID#>" onclick="enableEmployee(this)" 
                        <#
                        if(objRow.RoleCheck !="0")
                        {#>  checked="checked" <#}
                        #>
                        />
                        <#=objRow.RoleName#></td>              
                    <td class="GridViewLabItemStyle" id="tdLoginRoleID"  style="width:80px;text-align:left;display:none" ><#=objRow.RoleID#></td>
                    <td class="GridViewLabItemStyle" id="tdChkAll_<#=objRow.RoleID#>"  
                         <# if(objRow.EmpCheck =="0") {#> style="width:10px;text-align:left;display:none" <#} else {#> style="width:10px;text-align:left;"<#} #> >                       
                        <input type="checkbox" id="chkAll" onclick="chkAllEmp(this)" />
                    </td>
                    <td class="GridViewLabItemStyle" id="tdLoginRoleID_<#=objRow.RoleID#>"  style="width:620px;text-align:left;
                         <# if(objRow.EmpCheck =="0") {#>display:none" <#} else {#> display:block"<#} #> >
                      <#                       
                          var empLength= parseInt(objRow.Employee_ID.split('$').length); 
                          var empChkLength=0;                
                         if(objRow.EmpCheck !="0") 
                              empChkLength= parseInt(objRow.EmpCheck.split('$').length);                                                                                  
                         for(var s=0;s<empLength;s++)
                        { #>                                                           
                        <input type="checkbox" value="<#=objRow.Employee_ID.split('$')[s]#>" id="chkEmployee_<#=objRow.Employee_ID.split('$')[s]#>" onclick="countEmpCheck(this)" class="empCheckLength"   name="chkRoleEmp_<#=objRow.RoleID#>" style="width:24px;text-align:center; vertical-align: middle;margin-left:auto; margin-right:auto;"   
                           <# if(empChkLength>0){
                              for(var t=0;t<empChkLength;t++)
                        {#>                                 
                                <# if(objRow.Employee_ID.split('$')[s]==objRow.EmpCheck.split('$')[t])
                                    { #> checked="checked" <#} #>
                         <#} }#> />                                                                                                                                                                                                                                                  
                        <#=objRow.EmployeeName.split('$')[s]#>
                             <# if(s=="4" || s=="8" || s=="12" || s=="16" || s=="20" || s=="24" || s=="28" || s=="32" || s=="36")
                             {#><br /><#}#><#}
                        #>
                        </td>       
                           <td class="GridViewLabItemStyle" style="width:10px;display:none">
                                                <span id="spnRoleChange"  >0</span>
                                            </td>                                 
                    </tr>
        <#}       #>    
     </table>
    </script>
       <script type="text/javascript">
    function chkAllEmp(rowID) {
        if ($(rowID).closest('tr').find('#chkAll').is(':checked'))
            $(rowID).closest('tr').find('.empCheckLength').attr('checked', true);
        else
            $(rowID).closest('tr').find('.empCheckLength').attr('checked', false);
        countEmpCheck(rowID);
    }
    function enableEmployee(rowID) {
        RoleID = $(rowID).val();
        if ($(rowID).is(':checked')) {
            $(rowID).closest('tr').find("#tdLoginRoleID_" + RoleID).show();
            $(rowID).closest('tr').find("#tdChkAll_" + RoleID).show();
        }
        else {
            $(rowID).closest('tr').find("#tdLoginRoleID_" + RoleID).hide();
            $(rowID).closest('tr').find(":checkbox").attr("checked", false);
            $(rowID).closest('tr').find("#tdChkAll_" + RoleID).hide();
        }
    }

    function countEmpCheck(rowID) {
        if ($("input:checkbox:checked.empCheckLength").length > 0)
            $("#btnSave").show();
        else
            $("#btnSave").hide();

        if ($(rowID).closest('tr').find('.empCheckLength').is(':checked'))
            $(rowID).closest('tr').find('#spnRoleChange').text('1');
        else
            $(rowID).closest('tr').find('#spnRoleChange').text('0');
    }
    function pageLoad(sender, args) {
        if (!args.get_isPartialLoad()) {
            $addHandler(document, "keydown", onKeyDown);
        }
    }
    function onKeyDown(e) {
        if (e && e.keyCode == Sys.UI.Key.esc) {
            if ($find('mpNotification')) {
                $find('mpNotification').hide();
                $("#divEmpDetail").html('');
                $('#btnSave,#trNotification').hide();
                $("#spnNotification").text('');
            }
        }
    }
</script>
      <style>
  .hover{
    border-top: 3px solid #f00;
    border-bottom: 3px solid #f00;
    cursor:pointer;
}
</style>
</asp:Content>

