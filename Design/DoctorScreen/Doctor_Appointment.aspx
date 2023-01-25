<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="Doctor_Appointment.aspx.cs" Inherits="Design_DoctorScreen_Doctor_Appointment"
    Title="Untitled Page" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, 
PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Design/Purchase/EntryDate.ascx" TagName="Entrydate" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../Scripts/jquery-ui.js" type="text/javascript"></script>
    <script type="text/javascript">
        var PatientData = "";
        var DoctorID = "";
        $(document).ready(function () {
            loadData();
        });

        function loadData() {
            DoctorID = $("#<%=lblDoc_ID.ClientID %>").html();
       $.ajax({
           url: "Service/SearchAppointment.asmx/LoadAppointment",
           data: '{DoctorID:"' + DoctorID + '"}',
           type: "POST",
           contentType: "application/json;charset=utf-8",
           timeout: 120000,
           dataType: "json",
           success: function (result) {
               PatientData = jQuery.parseJSON(result.d);
               var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
               $('#PatientLabSearchOutput').html(output);
           },
           error: function (xhr, status) {
               alert("Error has occured ");
               window.status = status + "\r\n" + xhr.responseText;
           }
       });
   }

   function LoadAll_OnlinePatient() {
       DoctorID = $("#<%=lblDoc_ID.ClientID %>").html();
            $.ajax({
                url: "Service/SearchAppointment.asmx/LoadAll_OnlinePatient",
                data: '{DoctorID:"' + DoctorID + '"}',
                type: "POST",
                contentType: "application/json;charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    PatientData = jQuery.parseJSON(result.d);
                    var output = $('#tb_App').parseTemplate(PatientData);
                    $('#PatientLabSearchOutput').html(output);
                },
                error: function (xhr, status) {
                    alert("Error has occured ");
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function LoadAll_InOutPatient() {
            DoctorID = $("#<%=lblDoc_ID.ClientID %>").html();
        $.ajax({
            url: "Service/SearchAppointment.asmx/LoadAll_InOutPatient",
            data: '{DoctorID:"' + DoctorID + '"}',
            type: "POST",
            contentType: "application/json;charset=utf-8",
            timeout: 120000,
            dataType: "json",
            success: function (result) {
                PatientData = jQuery.parseJSON(result.d);
                var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
                $('#PatientLabSearchOutput').html(output);
            },
            error: function (xhr, status) {
                alert("Error has occured ");
                window.status = status + "\r\n" + xhr.responseText;
            }
        });
    }
    function loadData_WithCriteria(P_Type) {
        DoctorID = $("#<%=lblDoc_ID.ClientID %>").html();
       $.ajax({
           url: "Service/SearchAppointment.asmx/LoadAppointment_PType",
           data: '{DoctorID:"' + DoctorID + '",P_Type:"' + P_Type + '"}',
           type: "POST",
           contentType: "application/json;charset=utf-8",
           timeout: 120000,
           dataType: "json",
           success: function (result) {
               PatientData = jQuery.parseJSON(result.d);
               var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
               $('#PatientLabSearchOutput').html(output);
           },
           error: function (xhr, status) {
               alert("Error has occured ");
               window.status = status + "\r\n" + xhr.responseText;
           }
       });
   }
   //Patient Call flag and CallNo Update
   function UpdateCall(App_ID) {
       $('#btnSave').attr('disabled', true);
       $.ajax({
           url: "Service/SearchAppointment.asmx/UpdateCall",
           data: '{App_ID: "' + App_ID + '",DoctorID:"' + DoctorID + '"}', // parameter map
           type: "POST", // data has to be Posted    	        
           contentType: "application/json; charset=utf-8",
           timeout: 120000,
           dataType: "json",
           success: function (result) {
               if (result.d == "1") {
                   loadData();
                   //Gaurav             
                   PlaySound();
                   //alert("Patient Call Successfully");
                   $("#btnSave").attr('disabled', false);
               }
               else {
                   alert("Previous Patient Already Called");
               }
               $("#btnSave").attr('disabled', false);
           }
       });
   }
   var soundObject = null;
   function PlaySound() {
       if (soundObject != null) {
           document.body.removeChild(soundObject);
           soundObject.removed = true;
           soundObject = null;
       }
       soundObject = document.createElement("embed");
       soundObject.setAttribute("src", "../DoctorScreen/Sound/INTone.wav");
       soundObject.setAttribute("hidden", true);
       soundObject.setAttribute("autostart", true);
       document.body.appendChild(soundObject);
   }
   //Patient Inflag Update
   function UpdateIn(App_ID, PatientID, TransactionID, IsDone, LedgerTnxID) {
       $('#btnSave').attr('disabled', true);
       $.ajax({

           url: "Service/SearchAppointment.asmx/UpdateIn",
           data: '{App_ID: "' + App_ID + '",DoctorID:"' + DoctorID + '"}', // parameter map

           type: "POST", // data has to be Posted    	        
           contentType: "application/json; charset=utf-8",
           timeout: 120000,
           dataType: "json",
           success: function (result) {
               if (result.d == "1") {
                   loadData();
                   //alert("Patient IN Sucessfully");
                   $("#btnSave").attr('disabled', false);
                   //Server.Transfer("OPD.aspx"+Convert.ToString(PatientID+'#'+TransactionID+'#'+IsDone+'#'+LedgerTnxID));

                   
                   // data: '{PatientID:"'+PatientID+'",TransactionID:"'+TransactionID+'",IsDone:"'+IsDone+'",LedgerTnxID:"'+LedgerTnxID+'"}',

                   //window.location = "../CPOE/CPOE.aspx?PatientID=" + PatientID + "&TID=" + TransactionID + "&IsDone=" + IsDone + "&LnxNo=" + LedgerTnxID + "&App_ID=" + App_ID + "&PanelID=" + 1;
                   //window.location="save.php?type=deldownload&album="+album+"&id="+id;
                   
               }
               else {
                   alert("Previous Patient Already In");
               }
               $("#btnSave").attr('disabled', false);
           }
       });
   }
   function ViewPHistory(PatientID, TransactionID, IsDone, LedgerTnxID) {
       window.location = "OPD.aspx?PatientID=" + PatientID + "&TID=" + TransactionID + "&IsDone=" + IsDone + "&LnxNo=" + LedgerTnxID;
   }
   //Patient Inflag Update
   function UpdateOut(App_ID) {
       $('#btnSave').attr('disabled', true);
       $.ajax({
           url: "Service/SearchAppointment.asmx/UpdateOut",
           data: '{App_ID: "' + App_ID + '",DoctorID:"' + DoctorID + '"}', // parameter map
           type: "POST", // data has to be Posted    	        
           contentType: "application/json; charset=utf-8",
           timeout: 120000,
           dataType: "json",
           success: function (result) {
               if (result.d == "1") {
                   loadData();
                   //alert("Patient OUT Successfully");
                   $("#btnSave").attr('disabled', false);
               }
               else {
                   alert("Patient Not Out");
               }
               $("#btnSave").attr('disabled', false);
           }
       });
   }
   //Patient Uncall
   function UpdateUncall(App_ID) {
       $('#btnSave').attr('disabled', true);
       $.ajax({
           url: "Service/SearchAppointment.asmx/UpdateUncall",
           data: '{App_ID: "' + App_ID + '"}', // parameter map

           type: "POST", // data has to be Posted    	        
           contentType: "application/json; charset=utf-8",
           timeout: 120000,
           dataType: "json",
           success: function (result) {
               if (result.d == "1") {

                   loadData();
                   //alert("Patient Uncall Successfully");
                   $("#btnSave").attr('disabled', false);
               }
               else {
                   alert("Patient Not Uncall");
               }
               $("#btnSave").attr('disabled', false);
           }
       });
   }
   //Patient Hold or Rollback
   function Hold(App_ID) {
       $('#btnSave').attr('disabled', true);
       $.ajax({
           url: "Service/SearchAppointment.asmx/Hold",
           data: '{App_ID: "' + App_ID + '"}', // parameter map
           type: "POST", // data has to be Posted    	        
           contentType: "application/json; charset=utf-8",
           timeout: 120000,
           dataType: "json",
           success: function (result) {
               if (result.d == "1") {
                   loadData();
                   //alert("Patient Uncall Successfully");
                   $("#btnSave").attr('disabled', false);
               }
               else {
                   alert("Patient Not Uncall");
               }
               $("#btnSave").attr('disabled', false);
           }
       });
   }

    </script>
    <script type="text/javascript">
        function ReseizeIframe() {
            document.getElementById("iframePatient").style.width = "100%";
            document.getElementById("iframePatient").style.height = "100%";
            document.getElementById("iframePatient").style.display = "";

        }
    </script>
    <script id="tb_PatientLabSearch" type="text/html">
    <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" 
    style="width:890px;border-collapse:collapse;">
		<tr>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">MRNo</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:130px;">PatientName</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Age</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">App.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Time</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;width:5px;">LedgerNo</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;width:5px;">App_ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;width:5px;">PatientID</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;width:5px;">TransactionID</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;width:5px;">IsDone</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;width:5px;">flag</th>
         <th class="GridViewHeaderStyle" scope="col" style="width:5px;"></th>
         <th class="GridViewHeaderStyle" scope="col" style="width:5px;"></th>
         <th class="GridViewHeaderStyle" scope="col" style="width:5px;"></th>
         <th class="GridViewHeaderStyle" scope="col" style="width:5px;"></th>
         <th class="GridViewHeaderStyle" scope="col" style="width:5px;"></th>
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
          <#if(objRow.Hold==0){#>
                    <tr id="<#=objRow.LedgerTransactionNo#>" bgcolor="<#=objRow.BGColor#>" style="height: 10px" >
            <#}else{ #>
                <tr id="<#=objRow.LedgerTransactionNo#>" bgcolor="#F2DC76" style="height: 10px" >
              <#}#>    
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" ><#=objRow.MRNo#></td>
                    <td class="GridViewLabItemStyle" ><#=objRow.Pname#></td>
                    <td class="GridViewLabItemStyle" ><#=objRow.Age#></td>
                    <td class="GridViewLabItemStyle" ><#=objRow.App_No#></td>
                    <td class="GridViewLabItemStyle" ><#=objRow.A_date#></td>
                    <td class="GridViewLabItemStyle" ><#=objRow.A_Time#></td>
                    <td class="GridViewLabItemStyle" style="display:none;"><#=objRow.LedgerTransactionNo#></td>
                    <td class="GridViewLabItemStyle" style="display:none;"><#=objRow.App_ID#></td>
                    <td class="GridViewLabItemStyle" style="display:none;"><#=objRow.PatientID#></td>
                    <td class="GridViewLabItemStyle" style="display:none;"><#=objRow.TransactionID#></td>
                    <td class="GridViewLabItemStyle" style="display:none;"><#=objRow.IsDone#></td>
                    <td class="GridViewLabItemStyle" style="display:none;"><#=objRow.flag#></td>
               <#if(objRow.P_Out==0){#>
               <#if(objRow.IsCall==1)
               {
               if(objRow.P_In==1)
                {
               #>
               <td class="GridViewLabItemStyle" >
               <input type="button" value="Uncall" id="btnUncall" onclick="(UpdateUncall('<#=objRow.App_ID#>'));" disabled="disabled"/>
               <input type="button" value="Call" id="btncall" onclick="(UpdateCall('<#=objRow.App_ID#>'));" style="display:none;"/>
               </td>
               <#}
               else
               {#>
               <td class="GridViewLabItemStyle" ><input type="button" value="Uncall" id="btnUncall" onclick="(UpdateUncall('<#=objRow.App_ID#>'));" /><input type="button" value="Call" id="btncall" onclick="    (UpdateCall('<#=objRow.App_ID#>'));" style="display:none;"/></td>
               <#}
               }
               else
               {#>
                <td class="GridViewLabItemStyle" ><input type="button" value="Uncall" id="btnUncall" onclick="(UpdateUncall('<#=objRow.App_ID#>'));" style="display:none;"/><input type="button" value="Call" id="btncall" onclick="    (UpdateCall('<#=objRow.App_ID#>'));" /></td>
               <#}
               if(objRow.P_In==1){#>
               <td class="GridViewLabItemStyle" ><input type="button" value="Out" id="btnout" onclick="(UpdateOut('<#=objRow.App_ID#>'));"/><input type="button" value="In" id="btnIn" onclick="    (UpdateIn('<#=objRow.App_ID#>', '<#=objRow.PatientID#>', '<#=objRow.TransactionID#>', '<#=objRow.IsDone#>', '<#=objRow.LedgerTransactionNo#>'));" style="display:none;"/></td>
               <#}else{ #>
               <td class="GridViewLabItemStyle" >
                    <a target="iframePatient" onclick="ReseizeIframe();" href="../CPOE/CPOE.aspx?TID=<#=objRow.TransactionID#>&amp;LnxNo=<#=objRow.LedgerTransactionNo#>&amp;IsDone=1&amp;PatientID=<#=objRow.PatientID#>&amp;App_ID=<#=objRow.App_ID#>&amp;PanelID=1">   
                   <input type="button" value="In" id="btnIn" onclick="(UpdateIn('<#=objRow.App_ID#>', '<#=objRow.PatientID#>', '<#=objRow.TransactionID#>', '<#=objRow.IsDone#>', '<#=objRow.LedgerTransactionNo#>'));"/></a> <input type="button" value="Out" id="btnout" onclick="    (UpdateOut('<#=objRow.App_ID#>'));" style="display:none;"/></td>
               <#}#> 
               <#if(objRow.P_Out==1){#> 
               <td class="GridViewLabItemStyle" ><input type="button" value="Out" id="btnout" onclick="(UpdateOut('<#=objRow.App_ID#>'));" disabled="disabled"/><input type="button" value="Uncall" id="btnUncall" onclick="    (UpdateUncall('<#=objRow.App_ID#>'));" disable="disable"/></td>
               <#}#>
                <#if(objRow.P_In==1){#>
                <td class="GridViewLabItemStyle" ><input type="button" value="View" id="btnView" style=" display:none;" onclick="(ViewPHistory('<#=objRow.PatientID#>', '<#=objRow.TransactionID#>', '<#=objRow.IsDone#>', '<#=objRow.LedgerTransactionNo#>'));"/>
                                <input type="button" value="Hold" id="btnHold" onclick="(Hold('<#=objRow.App_ID#>'));"/>
                </td>       
                <#}#> 
                 <#}else{ #>
                 <td class="GridViewLabItemStyle" ></td>
                 <td class="GridViewLabItemStyle" ></td>
                <td class="GridViewLabItemStyle" ><input type="button" value="View" id="btnView" onclick="(ViewPHistory('<#=objRow.PatientID#>', '<#=objRow.TransactionID#>', '<#=objRow.IsDone#>', '<#=objRow.LedgerTransactionNo#>'));"/>
                <input type="button" value="Hold" id="btnHold" onclick="(Hold('<#=objRow.App_ID#>'));"/>
                </td>
                <#}#> 
               </tr>
        <#}#>
     </table>    
    </script>
     <script id="tb_App" type="text/html">
    <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_Data" 
    style="width:890px;border-collapse:collapse;">
		<tr>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">MRNo</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:130px;">PatientName</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Age</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">App.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">Date</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:50px;">Time</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;width:5px;">LedgerNo</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;width:5px;">App_ID</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;width:5px;">PatientID</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;width:5px;">TransactionID</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;width:5px;">IsDone</th>
            <th class="GridViewHeaderStyle" scope="col" style="display:none;width:5px;">flag</th>
         <th class="GridViewHeaderStyle" scope="col" style="width:5px;"></th>
         <th class="GridViewHeaderStyle" scope="col" style="width:5px;"></th>
         <th class="GridViewHeaderStyle" scope="col" style="width:5px;"></th>
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
                    <tr id="Tr1" bgcolor="<#=objRow.BGColor#>" style="height: 10px" >
                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" ><#=objRow.MRNo#></td>
                    <td class="GridViewLabItemStyle" ><#=objRow.Pname#></td>
                    <td class="GridViewLabItemStyle" ><#=objRow.Age#></td>
                    <td class="GridViewLabItemStyle" ><#=objRow.App_No#></td>
                    <td class="GridViewLabItemStyle" ><#=objRow.A_date#></td>
                    <td class="GridViewLabItemStyle" ><#=objRow.A_Time#></td>
                    <td class="GridViewLabItemStyle" style="display:none;"><#=objRow.LedgerTransactionNo#></td>
                    <td class="GridViewLabItemStyle" style="display:none;"><#=objRow.App_ID#></td>
                    <td class="GridViewLabItemStyle" style="display:none;"><#=objRow.PatientID#></td>
                    <td class="GridViewLabItemStyle" style="display:none;"><#=objRow.TransactionID#></td>
                    <td class="GridViewLabItemStyle" style="display:none;"><#=objRow.IsDone#></td>
                    <td class="GridViewLabItemStyle" style="display:none;"><#=objRow.flag#></td>
               <#if(objRow.P_Out==0){#>
               <#if(objRow.IsCall==1)
               {
               if(objRow.P_In==1)
                {
               #>
               <td class="GridViewLabItemStyle" >
               <input type="button" value="Uncall" id="Button1" style="display:none;" disabled="disabled"/>
               <input type="button" value="Call" id="Button2" style="display:none;" style="display:none;"/>
               </td>
               <#}
               else
               {#>
               <td class="GridViewLabItemStyle" ><input type="button" value="Uncall" id="Button3" style="display:none;" /><input type="button" value="Call" id="Button4"  style="display:none;"/></td>
               <#}
               }
               else
               {#>
                <td class="GridViewLabItemStyle" ><input type="button" value="Uncall" id="Button7"  style="display:none;"/><input type="button" value="Call" id="Button8" style="display:none;" /></td>
               <#}
               if(objRow.P_In==1){#>
               <td class="GridViewLabItemStyle" ><input type="button" value="Out" id="Button9" style="display:none;"/><input type="button" value="In" id="Button10"  style="display:none;"/></td>
               <#}else{ #>
               <td class="GridViewLabItemStyle" ><input type="button" value="In" id="Button11" style="display:none;" /><input type="button" value="Out" id="Button12" style="display:none;"/></td>
               <#}#> 
                
               <#if(objRow.P_Out==1){#> 
               <td class="GridViewLabItemStyle" ><input type="button" value="Out" id="Button13" style="display:none;" disabled="disabled"/><input type="button" value="Uncall" id="Button14" style="display:none;" /></td>
               <#}#>
                <#if(objRow.P_In==1){#>
                <td class="GridViewLabItemStyle" ><input type="button" value="View" id="Button15" style="display:none;"/>
                <input type="button" value="Hold" id="Button17"/>
                </td>       
                <#}#> 
                 <#}else{ #>
                 <td class="GridViewLabItemStyle" ></td>
                 <td class="GridViewLabItemStyle" ></td>
                <td class="GridViewLabItemStyle" ><input type="button" value="View" id="Button16" style="display:none;"/></td>
                <#}#> 
               </tr>
        <#}#>
     </table>    
    </script>

    <div id="Pbody_box_inventory">
        <div class="Outer_Box_Inventory" style="width: 99.7%">
            <div class="content" style="text-align: center;">
                <asp:Label ID="lblDoctor" runat="server" BackColor="#FFFFFF" Font-Bold="True" Font-Size="16pt"
                    ForeColor="#0066FF"></asp:Label>
                <asp:Label ID="lblDoc_ID" runat="server" Style="display: none;"></asp:Label>
                <asp:Label ID="lblroomNo" runat="server" Style="display: none;"></asp:Label><br />
                <input id="button_1" onclick="loadData_WithCriteria('A');" type="button" value="Appointment-A" 
                    style="background-color: navajowhite;display:none;" />
                <input id="button_2" onclick="loadData_WithCriteria('S');" type="button" value="Special-S" 
                    style="background-color: Gray;display:none;" />
                <input id="button_3" onclick="loadData_WithCriteria('R');" type="button" value="Report-R" 
                    style="background-color: Green;display:none;" />
                <input id="button_4" onclick="loadData();" type="button" value="All Pending" style="background-color: Yellow;" />
                     <input id="button5" onclick="LoadAll_InOutPatient();" type="button" value="Today Patient" style="background-color:Lime;" />
                    <input id="button6" onclick="LoadAll_OnlinePatient();" type="button" value="Online/Phone App. Patient" style="background-color:Gray;" />
                    <%--<asp:Button ID="btnRing" runat="server" ClientIDMode="static" OnClick="btnRing_Click" />--%>
            </div>
            <div class="content" id="PatientLabSearchOutput" style="max-height: 400px; overflow-y: auto;
                overflow-x: auto;">
            </div>
        </div>
    </div>
    <iframe id="iframePatient" name="iframePatient" src="" style="position: fixed; top: 0px; left: 0px; background-color: #FFFFFF; display: none;"
        frameborder="0" enableviewstate="true"></iframe>
</asp:Content>
